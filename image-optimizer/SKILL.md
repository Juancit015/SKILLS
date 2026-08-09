---
name: image-optimizer
description: Optimiza todas las imágenes de un proyecto web/multimedia convirtiéndolas a AVIF y WebP con las herramientas instaladas (avifenc, ImageMagick, cwebp, ffmpeg) y actualizando sus referencias. Usar cuando el usuario pida convertir imágenes, optimizar imágenes, reducir el peso de las imágenes, cambiar formato jpg/png a avif o webp, optimizar el contenido multimedia de un proyecto o acelerar la carga de un sitio.
---

# Optimizador global de imágenes (AVIF / WebP)

Convierte en masa todas las imágenes raster de un proyecto a **AVIF** y **WebP**, normaliza orientación, verifica la calidad con RMSE, y actualiza las referencias en el código. Reduce típicamente el peso de las imágenes un 90-98%.

## Flujo obligatorio

### 1. Verificar herramientas instaladas

```bash
for t in avifenc cwebp magick convert ffmpeg; do command -v "$t" >/dev/null 2>&1 && echo "$t: OK" || echo "$t: NO"; done
```

- **AVIF**: usa `avifenc` si existe; si no, ImageMagick solo si su delegate está activa: `magick -list format | grep -iE "AVIF|WEBP"`.
- **WebP**: usa `cwebp` si existe; si no, `magick` (delegate `WEBP* rw+`).
- Solo genera los formatos que las herramientas soporten; si una herramienta no produce un formato, se omite ese formato y se continúa con la otra.

### 2. Inventario

- Busca imágenes con glob: `**/*.jpg`, `**/*.jpeg`, `**/*.png`, `**/*.gif` — excluyendo `node_modules/`, `.git/` y `vendor/` de terceros.
- **Excluye**: SVG (vectorial, ya optimo), archivos que ya estan en AVIF/WebP e imágenes **animadas** (GIF/WebP animado: verifica con `magick img.gif -format "%n" info:` → si `n > 1` salta; si el usuario quiere animación, con `ffmpeg` se puede generar un WebP animado: `ffmpeg -i anim.gif -loop 0 -y anim.webp`, y confirma que tenga `n` frames > 1).
- Registra tamaño y resolución de cada original antes de tocar nada.
- Revisa si el proyecto usa **bundler** (`package.json` con Vite/Webpack) para saber cómo actualizar referencias en el paso 5.

### 3. Normalizar orientación — OBLIGATORIO antes de convertir

Los JPEG de cámaras/WhatsApp/Telegram llevan un flag EXIF `Orientation`. `-strip` lo elimina y, si no reordenas los píxeles primero, el convertido termina rotado. Reordena siempre antes de quitar metadatos:

```bash
# Averigua si la imagen tiene orientación distinta a la normal
magick "x.jpg" -format "%[orientation]" info:   # TopLeft = ya correcta
```

- **WebP con ImageMagick**: `-auto-orient` en la misma llamada, antes de `-strip`.

```bash
magick "x.jpg" -auto-orient -strip -quality 82 -define webp:method=6 "x.webp"
```

- **WebP con cwebp** (no auto-orienta): normaliza a temp PNG y usa ese como origen.

```bash
magick "x.jpg" -auto-orient "/tmp/norm.png"
cwebp -q 82 -m 6 -strip "/tmp/norm.png" -o "x.webp"
```

- **AVIF con avifenc**: `avifenc` no rota automática. Normaliza primero:

```bash
tmp=$(mktemp --suffix=.png)
magick "x.jpg" -auto-orient "$tmp"
avifenc -q 42 --speed 6 "$tmp" "x.avif"
rm -f "$tmp"
```

### 4. Conversión (paralelizada)

```bash
# AVIF — recuerda el -auto-orient del paso 3 si la imagen trae EXIF
avifenc -q 42 --speed 6 "x.jpg" "x.avif"

# WebP con ImageMagick (libwebp)   ← recuerda -auto-orient si hay EXIF
magick "x.jpg" -strip -quality 82 -define webp:method=6 "x.webp"

# WebP con cwebp (equivalente)
cwebp -q 82 -m 6 -strip "x.jpg" -o "x.webp"
```

Para procesos **robustos** con muchos archivos (nombres con espacios incluidos), usa `find ... -print0 | xargs -0 -P4` y una función, no `&` sueltos:

```bash
convert_one() {
  src="$1"; tmp=$(mktemp --suffix=.png)
  magick "$src" -auto-orient "$tmp"
  avifenc -q 42 --speed 6 "$tmp" "${src%.*}.avif" 2>/dev/null || true
  rm -f "$tmp"
  magick "$src" -auto-orient -strip -quality 82 -define webp:method=6 "${src%.*}.webp"
}
export -f convert_one
find assets -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 \
  | xargs -0 -P4 -I{} bash -c 'convert_one "$@"' _ {}
```

Ajusta `-P4` según el CPU (4 hilos es un buen equilibrio; no satures una CI).

- `-strip` elimina metadatos (EXIF/ICC/DPI) — seguro **después** del `-auto-orient`. Si un archivo necesita perfil de color exacto, omite `-strip` para ese archivo.
- PNG con transparencia: AVIF y WebP soportan alpha; comprobación de color visual después.
- Aplica al directorio `assets/` (o `img`/`public`/`static`) recorriendo subcarpetas completas si el proyecto es grande.

### 5. Verificar calidad — OBLIGATORIO

Compara cada conversión contra el original con **RMSE** normalizado:

```bash
rmse=$(magick "x.jpg" "x.avif" -metric RMSE -compare -format "%[distortion]" info: 2>/dev/null)
```

- Aceptable: **RMSE < 0.02** (diferencias apenas perceptibles). Si algún archivo supera **0.03**, sube su calidad (avifenc `-q 42` → `-q 34`; webp `82` → `88`) y vuelve a comparar ese archivo.
- El SSIM de ImageMagick puede dar lecturas erróneas con AVIF; usa RMSE siempre. Los temp PNG se generan desde el original sin pérdida, pero el RMSE debe compararse contra el **original**, nunca contra un temp.
- Si la imagen tenia EXIF de rotación, comprueba visualmente que la salida no quedó girada.

### 6. Actualizar referencias en el proyecto

#### HTML con `<img>`

Envuelve en `<picture>` sin mover nada de la imagen:

```html
<picture>
  <source srcset="assets/x.avif" type="image/avif">
  <source srcset="assets/x.webp" type="image/webp">
  <img src="assets/x.jpg" alt="..." class="card-bg">
</picture>
```

TODOS los atributos (`src`, `alt`, `class`, `loading`, `width`...) quedan en el `<img>` interno. Después revisa que el CSS de esa clase siga funcionando (clases con `position: absolute` siguen aplicando porque apuntan al `<img>`).

#### CSS con `url(...)`

Prioriza `image-set()` para tener AVIF + WebP + fallback en **una sola declaración** (sin depender del orden de cascada). Los navegadores antiguos ignoran la línea y usan el fallback `solid`:

```css
.x-fondo {
  background-image: url("assets/fondo.jpg");                 /* fallback universal */
  background-image: image-set(
    url("assets/fondo.avif") type("image/avif") 1x,
    url("assets/fondo.webp") type("image/webp") 1x,
    url("assets/fondo.jpg")  1x
  );
}
```

Doble declaración: la primera la ven todos los navegadores; la segunda solo los que soportan `image-set` y pisan la primera. Verificar con Playwright/inspección que el navegador objetivo cargue la versión AVIF.

#### JS y bundlers (Vite/Webpack)

Según cómo el proyecto consume la imagen:

1. **Imports estáticos de assets** (`import hero from "./assets/hero.jpg"`): cambia **solo la extensión** a `.avif` y el bundler genera la URL del archivo nuevo:

```js
import hero from "./assets/hero.avif";
```

No intentes reemplazar la variable en los usos: esa no cambia. El bundler resuelve la nueva extensión solo (Vite y Webpack resuelven `.avif` nativo).

2. **CSS-in-JS** (styled-components, Emotion, template literals con URLs): aplica el patrón `image-set()` del apartado CSS dentro del styled.

3. **String literales** en sitios estáticos sin bundler:

```js
// antes
img.src = "assets/hero.jpg";
// después
img.src = "assets/hero.avif";
```

En los tres casos no toques `vendor/` de terceros.

### 7. Opcional: imágenes responsive por ancho

Si el usuario lo pide (o márcala como mejora opcional), además del formato genera **variantes de anchos** y usa `srcset`/`sizes`:

```bash
magick "x.jpg" -auto-orient -strip -quality 82 -resize 400x      "x-400.webp"
magick "x.jpg" -auto-orient -strip -quality 82 -resize 800x      "x-800.webp"
avifenc -q 42 --speed 6 "x-800.jpg" ...                          # igual para AVIF
```

```html
<img
  src="assets/x-400.avif"
  srcset="assets/x-400.avif 400w, assets/x-800.avif 800w, assets/x.avif 1200w"
  sizes="(max-width: 600px) 100vw, 50vw"
  alt="...">
```

No hagas esto por defecto: solo cuando aporte (heroes, fotos a ancho completo). Para cards pequeñas el formato basta.

### 8. Reglas de cierre

- **NUNCA borres los originales** (jpg/png): quedan como fallback, para rollback, y para comparar.
- No conviertas favicon (`.ico`) ni archivos SVG.
- No conviertas nada que ya sea AVIF/WebP.
- No edites código que no tenga que ver con imágenes.
- Confirma que ninguna conversión quedó rotada (revisa imágenes que provengan de WhatsApp/cámara).

### Reporte final

Termina siempre con una tabla Markdown:

| Archivo | Original | AVIF | WebP | Ahorro |
|---|---|---|---|---|
| `assets/card_chat.jpg` | 590 KB | 12.7 KB | 26.6 KB | -98% |

y el total de ahorro del proyecto (peso total de imágenes antes vs. después).

## Tabla de ajuste rápido

| Caso | AVIF (`-q`) | WebP (`quality`) |
|---|---|---|
| Fotos reales | 42 | 82 |
| Arte planos/degradados | 35 | 75 |
| Calidad alta (si RMSE > 0.03) | 32 | 88 |
| Tamaño extremo (menor prioridad) | 50 | 70 |
| PNG con alpha | incluye alpha automático | incluye alpha automático |