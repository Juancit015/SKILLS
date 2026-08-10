# CHANGELOG

## [2026-08-09]

### Agregado

- Skill `repo-readme-changelog` reforzada: instalación como secuencia numerada con `git clone` incluido; etiquetas de SO fuera de los bloques de código y un bloque por distro (sin comentarios inline); verificación del mecanismo real de carga de `.env`; smoke test de arranque obligatorio de cada servicio documentado con reporte de fallos al usuario (sin tocar código); runtime documentado solo con respaldo probado; `STRUCTURE.md` también para arquitecturas en capas; URL de clone verificada contra `git remote -v`.
- `README.md` actualizado con la descripción detallada de la skill `repo-readme-changelog`.

### Corregido

- `README.md` regenerado: ruta de carpeta del árbol corregida (`design/platform-ui-design/`, real en el repo, no `design/web-platform-design/`).

### Agregado

- `README.md` con descripción del repositorio, índice de las 5 skills, estructura de carpetas y procedimiento de sincronización a `~/.config/opencode/skills`.
- `CHANGELOG.md` para registrar cambios de infraestructura y documentación del repositorio.
- Sección `STRUCTURE.md` en la skill `repo-readme-changelog` (`documentation/project-documentation-setup/SKILL.md`): criterios para decidir cuándo crear un `STRUCTURE.md` y sus reglas.