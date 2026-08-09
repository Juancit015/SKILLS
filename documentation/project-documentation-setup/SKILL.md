---
name: repo-readme-changelog
description: Create and maintain repository documentation and setup infrastructure, including README.md and CHANGELOG.md, for technical projects (backend, run scripts, DB, env vars) AND descriptive sites (institutional landing pages with no backend, README as a fact sheet with sections, institution, creator). Respects the existing stack and avoids unrelated code changes.
---

# Repo Documentation and Setup

Use this skill when the user wants a repository to have clear, professional documentation and practical base infrastructure files.

## Scope

This skill focuses on:

- `README.md`
- `CHANGELOG.md`
- `.env.example`
- setup and run instructions
- directory structure and project conventions
- helper scripts and base tooling
- service descriptions and environment notes

It does not change business logic, routes, models, or application behavior unless the user explicitly asks for that.

## Single Source of Truth (SSOT)

**The code, the database, and the repo's own scripts are the ONLY source of truth.** Never copy facts from a previous README, from memory, from generic templates, or from online patterns without verifying them in the project.

Before writing anything, verify in the actual repository:

- `requirements.txt` / `pyproject.toml` / `deno-lock` / `package.json` → the exact runtime version (example: `pandas==2.1.4` forces **Python 3.12 — 3.13+ does not compile it, it is not a "suggestion"**).
- `run.py`, `serve.sh`, `Makefile`, `npm scripts` → the exact start command for THIS project.
- `instance/database/*.db` (SQLite) or a seed script (`utils/seed.py`, `seed.sql`) → the REAL default users that exist. **If a user exists in the DB (e.g. `Juan David`, `ADMIN`) it MUST appear in the README's default-users table. If a user in an old README does not exist anymore in the DB, remove it.**
- `.env.example` and config modules → the REAL environment variables.

**Never write a version number, a port, a username, or a command that you did not verify inside the repo.**

## Workflow

1. Read the repository structure first (ALL of it: main folder + scripts + DB).
2. Identify the stack, entry points, existing tooling, and the database.
3. Create or improve `README.md` so it matches the ACTUAL project (SSOT above).
4. Add or update `CHANGELOG.md` with meaningful release-style entries describing the documentation changes too.
5. Add infrastructure files only when they are useful and consistent with the repo.
6. Keep all changes aligned with the existing architecture and style.
7. After editing, verify the docs via `diff` / checks and report which parts were verified against code/DB.

## Discovery Signals

Inspect these files and directories BEFORE writing anything:

- `package.json`, `pnpm-lock.yaml`, `yarn.lock`, `package-lock.json`
- `requirements.txt`, `pyproject.toml`, `Pipfile`, `poetry.lock`
- `composer.json`, `Gemfile`, `go.mod`, `Cargo.toml`, `pom.xml`, `deno.json`
- `Dockerfile`, `docker-compose.yml`, `.devcontainer/`, `Procfile`
- `.env`, `.env.example`, config modules, framework entry points, migration folders
- `Makefile`, npm scripts, shell scripts, CI files, deployment config: `run.py`, `server.js`, `serve.sh`, `manage.py`
- **the database file** (`instance/database/*.db`, `*.sqlite`, or a `seed.py`/`seed` script present in `utils/`)
- existing `README.md` sections that are stale or too generic
- missing setup notes or undocumented environment variables
- hardcoded paths, ports, or commands that should be documented
- missing changelog entries for infrastructure or user-visible work

## Profile Check (primero, SIEMPRE)

Antes de escribir nada, decide el perfil del proyecto con una pregunta clave:

**¿El proyecto usa tecnologías de backend tipo Python, Node/npm, PostgreSQL/SQLite, PHP, Go, Dart/Flutter, o tiene scripts de deploy/build, migraciones o .env?**
- Sí → **perfil técnico**: aplican las secciones de run/setup/env vars/DB **solo porque el programa necesita ejecutarse con esas tecnologías** (comandos exactos, versiones de runtime, dependencias, SO: la documentación técnica es la fuente de verdad de CÓMO EJECUTARLO). Todo lo indicado más abajo (SSOT, Run Procedures, DB) aplica solo a este perfil.
- No (solo HTML/CSS/JS estáticos que se abren o se sirven con un simple servidor) →
  **perfil descriptivo/institucional**: el README es una ficha, NO un manual técnico (ver abajo). **Prohibido incluir cualquier información técnica.**

Ejemplos reales que distinguen los dos perfiles:
- `iestpaijan` (web institucional estática: páginas de noticias, galerías, becas, modalidades) → **descriptivo**.
- app Flask/servicio con base de datos → **técnico**.
- landing de un producto o servicio (sin backend) → **descriptivo**.

## Regla de oro (decide TODO lo demás)

**La documentación técnica (runtime, setup, run, dependencias, SO, estructura de carpetas, tokens de diseño) SOLO se escribe si el proyecto realmente necesita ser ejecutado con una tecnología (backend, build, base de datos, scripts).**
Si el proyecto no se "ejecuta" —porque es un sitio estático, una landing o una web descriptiva—, NADA de técnico aparece: ni Stack, ni Estructura de carpetas, ni comandos, ni tokens, ni `python3 -m http.server`, ni `npx serve`, ni notas de despliegue como "subir a cualquier hosting". El README describe qué ES el sitio y qué contiene, nada más.

Esto es una prohibición, no una sugerencia. Si el lector necesita saber cómo correr el proyecto técnicamente, ese proyecto cae en el perfil técnico; si no, es descriptivo.

## README Descriptivo (web institucional / landing / sitio estático)

Cuando el proyecto es una web descriptiva (no un sistema con backend), el README pasa de "cómo correrlo/usarlo/instalarlo" a **"de eso se trata"**: institucional, institucional descriptiva, de producto o landing:

- Explica qué es y a qué se dedica: "Plataforma institucional", "Sitio estático del IESTPAIJÁN", "Landing corporativa de X", "Página de presentación de productos", etc. Haz la descripción DETALLADA (para el lector no técnico), no solo una frase.
- Identifica la entidad/autor detrás: `Creado por: ...`, `Institución:`, `Publicado por:`, (datos que vengan del usuario o evidentes del propio sitio, NO inventados).
- Lista las secciones reales que se pueden ver en la web: noticias, galería, transparencia, admisión, becas, R.M./resolución oficial visible en el site, etc. — un bloque "Secciones" o "Contenido".
- SI la web menciona hechos verificables en sí misma (una resolución ministerial publicada, "100% gratuito", leyes, cifras, eslogan, años de creación) reprodúcelos tal cual aparecen.
- Si hay fechas o datos históricos reales (año de creación en la web, hitos), inclúyelos.
- Quiénes están detrás: qué es el producto/organización, cómo se financia (si lo dice la web), dónde se ubica (dirección si aparece), contacto si visible.
- **PROHIBIDO (perfil descriptivo):** NO incluyas Stack, Estructura de carpetas (el árbol de archivos), comandos (ni "open index.html" ni "npx serve" ni ningún servidor), tokens de diseño, .env, dependencias, despliegue/hosting. Nada técnico, incluso si es "reproducible" o "estático".

## CHANGELOG en perfil descriptivo

- Si el sitio cambia en el tiempo (noticias, rediseños, nuevas secciones), mantenés un CHANGELOG sencillo con entradas descriptivas (`Agregado`, `Corregido`, `Cambiado`).
- No inventes entradas históricas que no se hayan hecho. Nada técnico aquí tampoco (nada de "migrado a tokens", "optimizado CSS") — solo cambios visibles o de contenido.

## Run Procedures by Project Profile

**ESTA sección aplica SOLO al perfil técnico** (proyectos que se ejecutan con backend/build/scripts). En perfil descriptivo NINGUNA de estas secciones aparece en el README.

Teach the README the concrete procedure to START the service, always derived from the project's own files (SSOT). Use these patterns as examples:

| Profile | Typical command (INSPECT THE REPO FIRST) | Pitfall to document |
|---|---|---|
| Flask app (`run.py`, `app/`) | `python run.py` | Server starts on another port? Tunnel auto-starts (Cloudflare `CLOUDFLARE_TUNNEL`)? Check logs |
| Static web + avatar/frames (`serve.sh`, iframe with relative URLs) | `./serve.sh` from the repo, then open `/web/index.html` | Relative paths (`../assets/..`) only work when serving the CONTENEDORA folder — never the repo inside itself |
| Node project (`package.json` `scripts`) | `npm run dev` / `npm start` | deps, engines |
| Python = "installation without compiling" | document the ONLY valid Python version | if constraints force 3.12, say so as a rule, not advice |

For EVERY project you document, the README run section must contain, in practice:

1. The exact runtime version (from `requirements.txt`/config).
2. The exact start command(s) (from `run.py` / `serve.sh` / `package.json`).
3. Ports, URLs, and any auto-generated URL (tunnel) e.g. `logs/tunel.txt`.
4. Env variables table (from `.env.example`/`config.py`, never invented).
5. Available services (`http.server`, tunnel, DB) and how to turn each OFF (`CLOUDFLARE_TUNNEL=0`).

## README Rules

- Explain what the project is and what problem it solves.
- **Estas reglas técnicas (prerequisites, setup, run, tests) aplican SOLO al perfil técnico.** En perfil descriptivo NO documentes cosas para correr instalar; describe qué es y qué contiene.
- Document prerequisites, setup, configuration, run, and test commands — all SSOT-verified.
- Stand the stack from the repo, never a generic template.
- Include a concise folder overview when it helps navigation.
- Describe environment variables in a table or compact list.
- Mention deployment or production notes only if they are real for the project.
- Avoid marketing language and avoid overexplaining obvious tooling.
- If the repo already has a clear README format, preserve its structure UNLESS the user asks for a rewrite.
- If the README contains a **default users table**, verify it against the DB/seed and UP UNIQUE rules (existing users unchanged).
- Never let the README show secrets.

## README Example (compact structure when the project lacks a convention)

````markdown
# Project Name

Short description of what the project does.

## Stack

- Backend: Flask
- Run to go: `uv venv --python 3.12 venv` (SSOT: pandas 2.1.4 does not compile on 3.13+)
- Database: SQLite/PostgreSQL
- Frontend: Jinja + Bootstrap

## Setup

1. Create the environment (SSOT version).
2. Install dependencies with the documented tool.
3. Copy `.env.example` to `.env`.
4. Run migrations or seed commands if applicable.

## Run

```bash
python run.py
```

## Environment

| Variable | Required | Description |
| --- | --- | --- |
| `SECRET_KEY` | yes | Application secret key |
````

## README Example (descriptive profile — institutional/static site)

```markdown
# IESTPAIJÁN — Portal institucional

Plataforma institucional del [IESTPAIJÁN], donde se publican noticias, galería,
convocatorias de admisión y la información oficial de la institución.
Instituto público de educación superior tecnológica creado en [año] y
licenciado por el Ministerio de Educación. Matrícula 100 % gratuita.

- **Institución:** Instituto de Educación Superior Tecnológico Público ...
- **Creado por:** ...
- **Eslogan:** ...
- **Secciones:** Inicio, Nosotros, Carreras/Programas, Noticias, Galería, Becas, Admisión
- **Resolución:** R.M. N° ... (tal como figura en la web)
- **Dirección:** ...

_No se incluyen Stack, Estructura, Run, tokens, ni despliegue: es una ficha descriptiva._
```

## CHANGELOG Rules

- Use clear dated entries.
- Summarize user-visible changes, infrastructure changes, and notable fixes.
- Keep entries short and factual.
- Group changes by release when the repo already follows that pattern.
- Do not invent history. Only document what is present or what you are actually adding.
- When the README is corrected against the DB (users, versions, ports), add a "Fixed" bullet explaining the correction.

## CHANGELOG Example

Prefer a Keep a Changelog-style entry when no project convention exists:

```markdown
### Fixed

- Corrected stale command names in installation notes.
- Default-users table now reflects the actual DB (added `Juan David`, removed stale entries).
```

## Infrastructure Rules

- Add `.env.example` when environment variables exist or are implied.
- Keep default values safe and non-secret.
- Add helper scripts only when they remove friction or clarify setup.
- Keep shell scripts portable and nothing hardcoded (they must work from the repo).
- If a project already has a preferred toolchain, extend it instead of introducing a new one.
- Avoid touching unrelated application code.

## Conflict Handling

- If documentation already follows a stable project convention, preserve it and improve accuracy within that structure.
- **If existing docs (parametric DBJ, old README, memory) contradict the code/DB → the SSOT wins. Correct the doc and call out the fix in the summary.**
- If the DB shows a user the old README omits → ADD it. If the README lists a user the DB never had → DELETE it from docs (mention in summary; do not delete from the DB).
- If setup commands are unclear, inspect scripts and entry points before inventing new commands.
- If secrets, tokens, or private values appear in examples → replace with placeholders.

## Quality Bar

After the work, the repository must state, from SSOT alone:

- the exact runtime it needs and WHY (one line each)
- the exact "start the service" procedure (command), port(s), and URLs
- a default-users table (if any) that matches the DB/seed 1:1
- a fresh env table
- reproducible setup (one command per step)
- documentation that matches the real project, not a template

## Output Style

- Prefer concise, accurate documentation.
- Keep the tone professional and practical.
- Mirror the repository's terminology.
- Use Markdown that is easy to scan.

## When Not To Use This Skill

- Full API reference documentation (OpenAPI / docs).
- Architecture decision records (hard dict).
- Product marketing copy.
- User manuals unrelated to repository setup.
- Legal, compliance, or security policy documentation.