# CHANGELOG

## [2026-08-11]

### Agregado

- 13 skills nuevas incorporadas al repositorio, organizadas en categorías por función:
  - `animation/` (nueva categoría): `animate`, `animation-vocabulary`, `find-animation-opportunities`, `improve-animations`, `review-animations` — de [emilkowalski/skills](https://github.com/emilkowalski/skills).
  - `design/` (ampliada): `impeccable` (de [pbakaus/impeccable](https://github.com/pbakaus/impeccable), bundle con scripts, requiere Node), `design-taste-frontend` (de [leonxlnx/taste-skill](https://github.com/leonxlnx/taste-skill)), `apple-design`, `emil-design-eng`, `prototype` — de [emilkowalski/skills](https://github.com/emilkowalski/skills).
  - `libraries/` (nueva categoría): `ask-sonner`, `pick-ui-library` — de [emilkowalski/skills](https://github.com/emilkowalski/skills).
  - `writing/` (nueva categoría): `humanizer` (de [blader/humanizer](https://github.com/blader/humanizer)).
- `README.md` reorganizado con tablas por categoría (design, animación, librerías, escritura, documentación/utiles) y árbol de estructura actualizado con las 19 skills.

## [2026-08-09]

### Agregado

- Skill `repo-readme-changelog` reforzada: instalación como secuencia numerada con `git clone` incluido; etiquetas de SO fuera de los bloques de código y un bloque por distro (sin comentarios inline); verificación del mecanismo real de carga de `.env`; smoke test de arranque obligatorio de cada servicio documentado con reporte de fallos al usuario (sin tocar código); runtime documentado solo con respaldo probado; `STRUCTURE.md` también para arquitecturas en capas; URL de clone verificada contra `git remote -v`.
- `README.md` actualizado con la descripción detallada de la skill `repo-readme-changelog`.

### Corregido

- `README.md` regenerado: ruta de carpeta del árbol corregida (`design/platform-ui-design/`, real en el repo, no `design/web-platform-design/`).

### Agregado (validado con loop de subagentes sobre MultiBot)

- Skill `repo-readme-changelog` reforzada (v5) en la regla de smoke test: **auditoría de URL de red** obligatoria (clasificar 401/403 = esperado con credenciales falsas vs 404/redirect/URL malformada = anomalía → sospechar del default de una env var, no del token); **causa raíz con segunda prueba** (curl independiente al endpoint + inspección del código de la librería instalada); **fix con formato verificado** (si el default apunta a un gateway/proxy, verificar su formato de ruta real antes de escribir la solución, tras detectar en MultiBot que el gateway enruta `<token>/<método>` sin `/bot`); **clasificación del arranque** en el resumen ("hasta la frontera de red" vs "arranque completo").

### Agregado

- `README.md` con descripción del repositorio, índice de las 5 skills, estructura de carpetas y procedimiento de sincronización a `~/.config/opencode/skills`.
- `CHANGELOG.md` para registrar cambios de infraestructura y documentación del repositorio.
- Sección `STRUCTURE.md` en la skill `repo-readme-changelog` (`documentation/project-documentation-setup/SKILL.md`): criterios para decidir cuándo crear un `STRUCTURE.md` y sus reglas.