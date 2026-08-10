# SKILLS — Skills personales para opencode

Repositorio de skills propias para [opencode](https://opencode.ai): conjuntos de instrucciones especializadas (`SKILL.md`) que se cargan bajo demanda cuando una tarea coincide con su descripción. Cada skill es una carpeta con un `SKILL.md` que declara su `name` y `description` en frontmatter.

La fuente de verdad es este repositorio: desde aquí se exportan las skills a la configuración de opencode (`~/.config/opencode/skills`), nunca al revés.

## Skills incluidas

| Skill | Carpeta | Para qué sirve |
| --- | --- | --- |
| `web-platform-design` | `design/platform-ui-design/` | Diseñar o rediseñar plataformas web de negocio (ERP, CRM, dashboards, backoffice, paneles con formularios y tablas densas) con un único sistema visual en todas las pantallas, preservando la lógica de la aplicación. |
| `ui-design-audit` | `design/ui-design-audit/` | Auditar interfaces web en busca de patrones genéricos de IA, jerarquía débil, estados faltantes y decisiones de diseño no verificables. Produce un veredicto (0-10), hallazgos con severidad y remediación priorizada. |
| `repo-readme-changelog` | `documentation/project-documentation-setup/` | Crear y mantener la documentación del repositorio (`README.md`, `CHANGELOG.md`, `.env.example`, setup y comandos) verificada contra el código y la base de datos reales (SSOT). Regenera desde cero: prohibido recuperar documentación previa del historial git. Distingue perfil técnico y descriptivo. En perfil técnico exige: instalación como secuencia numerada 1-6 que arranca en el `git clone`; requisitos previos; cada SO/distro con SU propio bloque de código (etiquetas fuera de los bloques, sin comentarios inline); versiones exactas de dependencias en el Stack; verificación del mecanismo real de carga de `.env` (`load_dotenv` vs `os.environ`); smoke test de arranque de cada servicio documentado (los fallos se reportan al usuario con causa y fix sugerido, sin tocar código); runtime documentado solo con respaldo probado; tabla de troubleshooting con mensajes de error literales (PEP 668, `ModuleNotFoundError`, env vars, incompatibilidades de runtime); y `STRUCTURE.md` para arquitecturas en capas con mapa "Dónde se edita cada cosa". |
| `image-optimizer` | `image-optimizer/` | Optimizar imágenes de un proyecto web convirtiéndolas en masa a AVIF y WebP (con `avifenc`, `cwebp`, ImageMagick, ffmpeg), normalizando orientación EXIF, verificando calidad con RMSE y actualizando las referencias en HTML/CSS/JS. Ahorro típico del 90-98 %. |
| `spec-hardener` | `specification/spec-hardener/` | Convertir propuestas, análisis o auditorías generadas por otros agentes de IA en un spec/prompt accionable con decisiones de diseño cerradas y tests verificables. Cierra iteración tras iteración un único documento vivo. |

## Estructura del repositorio

```
SKILLS/
├── design/
│   ├── platform-ui-design/SKILL.md      → skill: web-platform-design
│   └── ui-design-audit/SKILL.md         → skill: ui-design-audit
├── documentation/
│   └── project-documentation-setup/SKILL.md  → skill: repo-readme-changelog
├── image-optimizer/
│   └── SKILL.md                         → skill: image-optimizer
├── specification/
│   └── spec-hardener/SKILL.md           → skill: spec-hardener
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