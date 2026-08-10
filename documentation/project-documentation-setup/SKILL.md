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

**Regeneración desde cero:** si la documentación fue eliminada o se pide regenerarla, está PROHIBIDO recuperar su versión anterior del historial git (`git show <commit>:README.md`, `git log -p`, restaurar borrados o revisar otra rama), incluso para "verificarla". La única fuente es el estado actual del repo (working tree, código, DB, scripts). Si el resultado coincide con la doc previa, debe surgir de que el SSOT es exacto — nunca de copiarla.

## Workflow

1. Read the repository structure first (ALL of it: main folder + scripts + DB). **Sin consultar versiones previas de la documentación en el historial (git log/show de docs).**
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
- `git remote -v` (remote real de origin) — la URL de `git clone` del README debe coincidir con ella; si el remote es SSH (`git@github.com:owner/repo.git`), documenta la URL pública equivalente `https://github.com/owner/repo.git` (clonable sin clave SSH)

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

## STRUCTURE.md (solo si la estructura lo amerita)

Un `STRUCTURE.md` es un mapa del repositorio para quien va a mantner o desarrollar el proyecto. Se crea SOLO cuando la estructura tiene suficiente enjundia (varias carpetas con lógica interna, assets, fuentes de contenido) como para merecer su propio documento:

**SI (crea STRUCTURE.md):** directorio organizado por secciones (múltiples carpetas `portal/`), múltiples fuentes de contenido (arrays en JS, carpetas de imágenes por evento/año), recursos (CSS por sección, fuentes/íconos locales), scripts de datos. **TAMBIÉN SI: aplicaciones/paquetes con arquitectura en capas (2+ niveles de profundidad): controladores/handlers, services, utils, modelos y tests con mocks — donde el mantenedor necesita ubicar dónde se edita cada comportamiento (ej. un bot con `bot/{handlers,services,utils}` + `tests/mocks` es SUFICIENTE para su propio mapa; la regla no es "solo webs de contenido").**
- Un README con un bloque "Estructura" NO sustituye al STRUCTURE.md cuando el repo califica: el README resume el propósito de cada directorio; STRUCTURE.md detalla dónde se edita cada cosa (archivo ↔ función).

Reglas del STRUCTURE.md:

- **Es tan técnico como haga falta**: aquí sí caben carpetas, rutas de imágenes, comandos de ejecución local y explicación de dónde se edita cada contenido — porque su propósito es mantener/depurar, no presentar el proyecto.
- **SSOT igual que el README**: cada carpeta y archivo mencionado debe existir realmente (`ls`/`find` primero); no inventar rutas ni archivos.
- **No repite la ficha del README**: no incluye descripción institucional, misión, entidad detrás, ni secciones visibles del sitio (eso es del README). Solo organização técnica.
- **Formato sugerido:** árbol corto con comentario por carpeta clave + sección "Dónde se edita cada contenido/formación" (tabla) + sección de assets/recursos con la forma (AVIF/WebP + fallback) si es relevante.
- Cuando existe STRUCTURE.md, el README descriptivo cierra con una línea de navegación técnica al final, tipo:
  `> **Estructura del repositorio:** consultar [STRUCTURE.md](STRUCTURE.md).`
  Solo añadirla si el archivo existe; no es info técnica dentro del README, es un acceso: el lector que quiera estructura la encuentra, el que no, la ignora.
- El nombre `STRUCTURE.md` se usa tal cual (raíz del repo).

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

### Instalación completa (secuencia numerada, perfil técnico)

Cuando el proyecto se instala desde Git, la instalación se documenta como UN bloque de pasos numerados que ARRANCA en el clone — prohibido separar el clone del setup en otra sección:

1. **Requisitos previos** (paso 1): lo que hay que tener en el sistema ANTES de clonar — runtime y versión, Git, herramientas de SO (ffmpeg, compiladores) con el comando de instalación por OS.
2. `git clone <url pública>` + `cd <repo>`.
3. Crear/activar el venv (con el binario `python` real del sistema).
4. Configurar `.env` (copiar de `.env.example`).
5. Instalar dependencias.
6. Ejecutar.

PROHIBIDO documentar la variante por SO como comentario inline en la misma línea del comando (`python -m venv venv      # Windows: venv\Scripts\activate`) o como alternativa pegada en la misma línea (`python multibot.py    # o: python3 multibot.py`). Estilo obligatorio — cada SO con su comando separado y la info extra en bloques propios (patrón sgrv):

- Cada comando con variante por SO va en SU PROPIO bloque de código, con la etiqueta del SO como texto ANTES del bloque (ver regla de etiquetas más abajo): ejemplo, activar el venv → texto `Linux / macOS:` → bloque `source venv/bin/activate`; texto `Windows (PowerShell):` → bloque `venv\Scripts\Activate.ps1`; texto `Windows (CMD):` → bloque `venv\Scripts\activate.bat`.
- **Mecanismo de carga de env vars (verificado SIEMPRE):** antes de documentar el paso ".env", verificar con grep cómo el programa LEE las variables: `load_dotenv()`/`dotenv` (carga real) vs `os.environ.get()` puro (NO lee .env). Si el proyecto NO carga `.env`:
  - El paso de configuración documenta el mecanismo REAL (export de variables o inline `VAR=... python <entry>`), NUNCA "copia .env y rellena" como paso efectivo.
  - Fila de troubleshooting: `Error: falta la variable de entorno X` con `.env` rellenado → causa: el proyecto no carga `.env` → solución: exportar las variables (o añadir loader — decisión del mantenedor).
  - **Reportar el hallazgo al usuario** (la skill NO modifica código): si `.env.example`/doc prometen `.env` pero el código no lo lee, es un desajuste que se documenta tal cual y se reporta en el resumen como candidato de fix.
- **Etiquetas de SO FUERA del bloque de código:** la etiqueta (`# Linux / macOS`, `# Windows (CMD)`, `# Debian/Ubuntu`…) va como texto propio (párrafo o negrita) ANTES del bloque de código; DENTRO del bloque va SOLO el comando. Motivo: dentro de bloques `cmd`/`powershell`/`bash`, GitHub renderiza la línea `# ...` como un comando más, confundiendo al lector.
- La info extra/explicativa va en párrafos independientes DESPUÉS del comando (qué hace el comando, advertencias ⚠, comandos alternativos de instalación de herramientas por distro en su propio bloque).
- Si una alternativa solo aplica a un subconjunto (ej. Python 3.13+ → `uv venv --python 3.12 venv`), se separa en su propio bloque con su condición ("Si tu Python es X..."), con su explicación y su forma de instalar la herramienta.
- El lector debe poder copiar-pastear el bloque de SU SO sin editar nada.

- **Intérprete y venv (imprescindible):** la doc deja claro que TODOS los comandos de ejecución corren CON el venv activado, y que `python`/`python3` deben ser los DEL venv (verificable: `which python` → ruta dentro del venv). Si el proyecto arranca con varios binarios posibles en el sistema (`python` vs `python3` pueden apuntar a intérpretes distintos: el del venv vs el del sistema), la doc elige UN binario canónico tras activar el venv y NO ofrece alternativas inline.
- **Análisis de librerías del proyecto:** derivar de `requirements.txt`/`pyproject` las librerías principales Y las dependencias transitivas notables que pueden aparecer en errores del usuario — si el nombre pip difiere del nombre de importación (ej. `python-telegram-bot` → `import telegram`), documentar esa equivalencia en la tabla de troubleshooting para que `ModuleNotFoundError: No module named 'telegram'` sea diagnosticable.

Si el proyecto aborta por env vars obligatorias (fail-fast en el entry point), la doc incluye en su tabla de troubleshooting una fila con el mensaje de error EXACTO del programa (ej. `Error: falta la variable de entorno BOT_TOKEN`) → Causa: env var no rellenada → Solución: editar `.env` (paso 3) o exportarla antes del paso de ejecución.

- **Verificación de arranque (smoke test obligatorio):** ejecutar CADA servicio ejecutable que se documente — entry point principal (`.py`), scripts (`serve.sh`, seeds, `manage.py`), servicios auxiliares — hasta la frontera de credenciales o red (o con valores de prueba), verificando que arrancan en el runtime documentado. Si un servicio falla por bug o incompatibilidad del proyecto: **reportarlo SIEMPRE al usuario con el mensaje de error, la causa raíz y el fix sugerido (la decisión de arreglar es del mantenedor — la skill NO toca código)**. Si no se puede ejecutar (sin entorno), declararlo explícitamente en el resumen. Si el programa adopta (o hereda) un runtime que rompe librerías (ej. Python 3.14 + python-telegram-bot 21.x → `RuntimeError: There is no current event loop`), la doc:
  - fija el rango de Python VERIFICADO (ej. "Python 3.11+ probado en 3.11 y 3.14"), nunca "X o superior" sin prueba;
  - añade fila en troubleshooting con el mensaje del RUNTIME y su causa/arreglo (actualizar la librería o bajar el runtime).
- **Cada SO/distro con su propio bloque:** prohibido condensar varias distros en una sola línea o párrafo (ej. "En Fedora: sudo dnf… En Arch: sudo pacman… En macOS: brew…"). Cada una con su etiqueta y su bloque de código propio; el lector de cada OS copia su bloque sin editar.

## README Rules

- Explain what the project is and what problem it solves.
- **Estas reglas técnicas (prerequisites, setup, run, tests) aplican SOLO al perfil técnico.** En perfil descriptivo NO documentes cosas para correr instalar; describe qué es y qué contiene.
- Document prerequisites, setup, configuration, run, and test commands — all SSOT-verified.
- En perfil técnico, el bloque de instalación abre con un item "Requisitos previos" (paso 1 de la secuencia): runtime y versión, Git y herramientas de sistema necesarias, con comando de instalación por OS.
- Cada dependencia principal del Stack lleva su versión/rango EXACTO tomado de `requirements.txt`/`pyproject.toml` (ej. `Flask 3.0.3`, `python-telegram-bot ≥ 21.0,<22.0`) — prohibido un Stack sin versiones.
- Cuando existan fallos de instalación conocidos y verificables (PEP 668 / externally-managed-environment, binarios que no existen en el host, herramientas ausentes, intérprete del sistema sin venv → `ModuleNotFoundError: No module named '<paquete>'`), el README cierra con una tabla Error/Causa/Solución — cada fila extraída de un error real, no inventado. La fila de `ModuleNotFoundError` apunta a: venv no activado o intérprete equivocado → `source <venv>/bin/activate` (o `<venv>/bin/python <entry>`).
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
- **Si el usuario pide regenerar la documentación después de eliminarla → regeneración DESDE CERO: no usar `git show` ni restauraciones para recuperar la versión borrada; reconstruir solo desde el estado actual. Al reportar, indicar explícitamente si se consultó el historial (debe ser "no").**
- **Si el repo fue movido a otra cuenta/org o es un clon (remote ≠ repo documentado): la URL de `git clone` del README queda obsoleta. Verificar contra `git remote get-url origin`, usar la URL pública (`https://...` si el remote es SSH), corregirla y registrar el arreglo como bullet `Fixed` en el CHANGELOG.**

## Quality Bar

After the work, the repository must state, from SSOT alone:

- the exact runtime it needs and WHY (one line each)
- the exact "start the service" procedure (command), port(s), and URLs
- a default-users table (if any) that matches the DB/seed 1:1
- a fresh env table
- reproducible setup (one command per step)
- documentation that matches the real project, not a template
- the `git clone` URL in the README matches `git remote -v` (SSH remote → public `https://github.com/<owner>/<repo>` in the README)

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