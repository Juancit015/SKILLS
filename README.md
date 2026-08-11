# SKILLS — Skills personales para opencode

Repositorio de skills propias para [opencode](https://opencode.ai): conjuntos de instrucciones especializadas (`SKILL.md`) que se cargan bajo demanda cuando una tarea coincide con su descripción. Cada skill es una carpeta con un `SKILL.md` que declara su `name` y `description` en frontmatter.

La fuente de verdad es este repositorio: desde aquí se exportan las skills a la configuración de opencode (`~/.config/opencode/skills`), nunca al revés.

## Skills incluidas

### Design (interfaz y frontend)

| Skill | Carpeta | Para qué sirve |
| --- | --- | --- |
| `web-platform-design` | `design/platform-ui-design/` | Diseñar o rediseñar plataformas web de negocio (ERP, CRM, dashboards, backoffice, paneles con formularios y tablas densas) con un único sistema visual en todas las pantallas, preservando la lógica de la aplicación. |
| `ui-design-audit` | `design/ui-design-audit/` | Auditar interfaces web en busca de patrones genéricos de IA, jerarquía débil, estados faltantes y decisiones de diseño no verificables. Produce un veredicto (0-10), hallazgos con severidad y remediación priorizada. |
| `impeccable` | `design/impeccable/` | Diseñar, rediseñar, pulir o criticar frontends con estándar de director de diseño award-winning. Cubre auditar, adaptar, animar, colorear, extraer, endurecer, optimizar y probar cambios en vivo en el navegador. Requiere Node. |
| `design-taste-frontend` | `design/design-taste-frontend/` | Skill anti-slop para landing pages, portfolios y rediseños: lee el brief, infiere la dirección de diseño y evita interfaces que se ven como plantilla. De [leonxlnx/taste-skill](https://github.com/leonxlnx/taste-skill). |
| `apple-design` | `design/apple-design/` | Principios de diseño de interfaces y motion física de Apple (Apple Design Awards) traducidos para la web: gestos, springs, materiales translúcidos, tipografía, reduced-motion. |
| `emil-design-eng` | `design/emil-design-eng/` | Filosofía de Emil Kowalski sobre polish de UI, decisiones de movimiento y detalles invisibles que hacen que el software se sienta excelente. |
| `prototype` | `design/prototype/` | Construir múltiples versiones genuinamente distintas de una pieza de UI, renderizadas detrás de un selector visual para compararlas en vivo y promocionar la mejor. |

### Animación y motion

| Skill | Carpeta | Para qué sirve |
| --- | --- | --- |
| `animate` | `animation/animate/` | Construir una animación desde cero tomando las decisiones en el orden correcto: propósito, herramienta, propiedades, curva, duración, interrupción y salida. |
| `review-animations` | `animation/review-animations/` | Revisar código de animación contra un estándar alto de craft. Por defecto señala problemas; la aprobación se gana. |
| `improve-animations` | `animation/improve-animations/` | Auditar todo el motion de un codebase y producir un plan priorizado y auto-contenido que cualquier agente pueda ejecutar (solo lectura). |
| `find-animation-opportunities` | `animation/find-animation-opportunities/` | Buscar en una UI los lugares que se beneficiarían de animar (y rechazar los que no) con valores exactos propuestos, sin implementar. |
| `animation-vocabulary` | `animation/animation-vocabulary/` | Glosario inverso: convertir la descripción vaga de un efecto ("la cosa que rebota") en su término exacto para promptear mejor a una IA. |

### Librerías y componentes

| Skill | Carpeta | Para qué sirve |
| --- | --- | --- |
| `pick-ui-library` | `libraries/pick-ui-library/` | Elegir la librería correcta para una tarea frontend (números, OTP, charts, comandos, virtualización, drag & drop, toasts, estado, estilos) de una lista curada y opinada. |
| `ask-sonner` | `libraries/ask-sonner/` | Guía de Sonner, la librería de toasts de Emil Kowalski: setup, estilos, temas, toasts de promesa/loading y troubleshooting de problemas comunes. |

### Escritura

| Skill | Carpeta | Para qué sirve |
| --- | --- | --- |
| `humanizer` | `writing/humanizer/` | Eliminar señales de texto generado por IA (simbolismo inflado, lenguaje promocional, em dashes, voz pasiva, regla de tres, frases de relleno) para que suene natural y humano. Basada en la guía de Wikipedia. |

### Documentación, proyectos y utilidades

| Skill | Carpeta | Para qué sirve |
| --- | --- | --- |
| `repo-readme-changelog` | `documentation/project-documentation-setup/` | Crear y mantener la documentación del repositorio (`README.md`, `CHANGELOG.md`, `.env.example`, setup y comandos) verificada contra el código y la base de datos reales (SSOT). Regenera desde cero: prohibido recuperar documentación previa del historial git. Distingue perfil técnico y descriptivo. En perfil técnico exige: instalación como secuencia numerada 1-6 que arranca en el `git clone`; requisitos previos; cada SO/distro con SU propio bloque de código (etiquetas fuera de los bloques, sin comentarios inline); versiones exactas de dependencias en el Stack; verificación del mecanismo real de carga de `.env` (`load_dotenv` vs `os.environ`); smoke test de arranque de cada servicio documentado (los fallos se reportan al usuario con causa y fix sugerido, sin tocar código); runtime documentado solo con respaldo probado; tabla de troubleshooting con mensajes de error literales (PEP 668, `ModuleNotFoundError`, env vars, incompatibilidades de runtime); y `STRUCTURE.md` para arquitecturas en capas con mapa "Dónde se edita cada cosa". |
| `project-closeout` | `documentation/project-closeout/` | Auditoría basada en evidencia de un proyecto existente y, si se aprueba, refactor a arquitectura limpia en capas y cierre para publicación. Validación real (smoke tests con prueba de causa raíz). |
| `image-optimizer` | `image-optimizer/` | Optimizar imágenes de un proyecto web convirtiéndolas en masa a AVIF y WebP (con `avifenc`, `cwebp`, ImageMagick, ffmpeg), normalizando orientación EXIF, verificando calidad con RMSE y actualizando las referencias en HTML/CSS/JS. Ahorro típico del 90-98 %. |
| `spec-hardener` | `specification/spec-hardener/` | Convertir propuestas, análisis o auditorías generadas por otros agentes de IA en un spec/prompt accionable con decisiones de diseño cerradas y tests verificables. Cierra iteración tras iteración un único documento vivo. |

## Estructura del repositorio

```
SKILLS/
├── animation/
│   ├── animate/SKILL.md                 → skill: animate
│   ├── animation-vocabulary/SKILL.md    → skill: animation-vocabulary
│   ├── find-animation-opportunities/SKILL.md → skill: find-animation-opportunities
│   ├── improve-animations/SKILL.md      → skill: improve-animations
│   └── review-animations/SKILL.md       → skill: review-animations
├── design/
│   ├── platform-ui-design/SKILL.md      → skill: web-platform-design
│   ├── ui-design-audit/SKILL.md         → skill: ui-design-audit
│   ├── impeccable/SKILL.md              → skill: impeccable
│   ├── design-taste-frontend/SKILL.md   → skill: design-taste-frontend
│   ├── apple-design/SKILL.md            → skill: apple-design
│   ├── emil-design-eng/SKILL.md         → skill: emil-design-eng
│   └── prototype/SKILL.md               → skill: prototype
├── documentation/
│   ├── project-documentation-setup/SKILL.md  → skill: repo-readme-changelog
│   └── project-closeout/SKILL.md        → skill: project-closeout
├── image-optimizer/
│   └── SKILL.md                         → skill: image-optimizer
├── libraries/
│   ├── ask-sonner/SKILL.md              → skill: ask-sonner
│   └── pick-ui-library/SKILL.md         → skill: pick-ui-library
├── specification/
│   └── spec-hardener/SKILL.md           → skill: spec-hardener
├── writing/
│   └── humanizer/SKILL.md               → skill: humanizer
├── sync-to-opencode.sh                  → exporta las skills a opencode
├── README.md
└── CHANGELOG.md
```

El destino en `~/.config/opencode/skills` usa el `name` del frontmatter, no el nombre de la carpeta en el repo (ej.: `design/platform-ui-design/` se instala como `web-platform-design`).

## Requisitos

- Bash (`sync-to-opencode.sh` usa `set -euo pipefail`).
- Utilidades estándar de Unix: `find`, `sort`, `awk`, `cp`, `rm`, `diff`, `mktemp`.
- opencode con el directorio de skills `~/.config/opencode/skills`.

## Sincronizar las skills a opencode

```bash
bash sync-to-opencode.sh
```

El script:

1. Recorre todos los `SKILL.md` del repositorio.
2. Extrae el `name:` del frontmatter de cada uno.
3. Copia la carpeta de cada skill a `~/.config/opencode/skills/<name>/`.
4. Solo reemplaza las skills que cambiaron; reporta el resumen de `nueva(s)`, `renovada(s)` y `sin cambios` al final.

La ruta de origen está fijada en el propio script (`/home/juan/Escritorio/SKILLS`); la de destino usa `$HOME`. No requiere variables de entorno ni argumentos.

## Añadir o modificar una skill

1. Crea o edita la carpeta de la skill con su `SKILL.md` (frontmatter: `name` + `description`; luego el cuerpo con las instrucciones de la skill).
2. Ejecuta `bash sync-to-opencode.sh` para exportarla.
3. Verifica con `ls ~/.config/opencode/skills` que aparezca.

Una skill se carga cuando la descripción de la tarea coincide con su `description`: prueba la skill desde opencode después de sincronizar.

## Verificación

Tras sincronizar, los nombres en `~/.config/opencode/skills` deben coincidir 1:1 con los `name` del frontmatter de cada `SKILL.md` del repo. Si una skill no aparece, comprueba que declare `name:` en las primeras líneas del archivo.