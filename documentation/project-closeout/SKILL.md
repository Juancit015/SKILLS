---
name: project-closeout
description: Take an EXISTING, WORKING project through an evidence-based audit and, when requested/approved, through refactor and closeout to a publishable state. The flow: audit/diagnosis, refactor to a clean layered architecture IF the project is disorganized (monolith, mixed layers, hardcoded secrets, no tests) preserving behavior, then closeout (doc sync, secret scan, Docker hardening, approved commit/push). Phased implementation with EXPLICIT user approval at every step and real validation (smoke tests with root-cause proof). Use when the user asks to "close", "publish", "prepare for release/entrega", "auditar antes de commit", "revisión pre-publicación", "dejar listo el repo", "limpiar/ordenar el código", "refactorizar" or hand off a project. Never commits or pushes automatically.
---

# Project Closeout (con Refactor)

Methodology to take an EXISTING, WORKING project from its current state to a publishable state (public repo, delivery, handoff, release) without coupling to any specific stack. Works for Python, Node.js, web apps, APIs, bots, Dockerized projects and plain repos. The skill is an ORCHESTRATOR: the analysis decides which stage applies (refactor, closeout, or both) and which controls are relevant; it never imposes a template.

Flujo único, sin selector manual: **auditoría/diagnóstico → etapa refactor (solo si hay desorden) → evaluación → etapa cierre (propuesta, no impuesta)**.

## Regla fundamental: autorización granular

Distintos niveles de acción requieren aprobaciones independientes:

1. **Analizar / informar** — autorizado desde el inicio (nunca requiere aprobación).
2. **Modificar código o configuración del proyecto** — SOLO tras aprobación de la propuesta correspondiente.
3. **Commit** — aprobación explícita e independiente (nunca automático).
4. **Push** — aprobación explícita e INDEPENDIENTE de la del commit (puede rechazarse el push aunque se apruebe el commit).

Nunca se agrupan estas autorizaciones entre sí ni se dan por implicadas. Si el usuario solo pidió "analiza", no se toca nada; si aprobó un paquete de refactor, no se commitea por ello; si se commiteó, no se pushea por ello.

## Reglas de seguridad (duras)

- NUNCA ejecutar `git commit` o `git push` automáticamente. El push requiere decisión aparte del commit.
- NUNCA tocar código, config, `.env`, cookies, sesiones o archivos generados sin aprobación de la fase de implementación.
- NUNCA mostrar, versionar o documentar secretos (tokens, API keys, sesiones, cookies). Reemplazar con placeholders desde el primer mensaje.
- NO recuperar documentación previa del historial git al regenerar docs: el SSOT es el working tree + DB + scripts actuales.
- Cero acción fuera del alcance acordado (no features nuevas, no dependencias extra, no reestructura no pedida).
- Los hallazgos se documentan tal cual existen; la decisión de corregir es SIEMPRE del mantenedor.

## Cinco buckets de clasificación (todo hallazgo se clasifica, nada queda suelto)

| Bucket | Definición | Ejemplo genérico |
|---|---|---|
| **REQUISITOS** | Lo que el proyecto realmente necesita (SSOT del código, DB, scripts) | "La URL base debe terminar en `bot`+token" |
| **HALLAZGOS** | Problemas o inconsistencias detectadas, con evidencia (log literal, diff, status) | "El arranque sale en 404 incluso con token válido" |
| **RECOMENDACIONES** | Mejoras propuestas por el agente (no implementadas por sí solas) | "Extraer la IO externa a un módulo de servicios" |
| **DECISIONES** | Puntos que requieren aprobación del usuario (paquete, fix, commit, push…) | "¿Aplico este paquete de refactor?" |
| **SUPOSICIONES** | Información inferida por el agente, declarada expresamente y marcada como verificable | "El proxy enruta `<token>/<método>`" (puede ser falsa; se verifica) |

Regla: una SUPOSICIÓN que la evidencia contradice se descarta y se reporta; jamás se escribe en la documentación como hecho.

## Fase 0 — Auditoría y diagnóstico (siempre primero)

Estado real sin opiniones: `git status --short`, `git log --oneline -10`, `git remote -v`, `ls -la` (detectar `.env`, `.gitignore`, `.dockerignore`, carpetas generadas, cookies/sesiones), inventario del stack (`package.json`/`requirements.txt`/`pyproject.toml`/`Dockerfile`/entry points), tests existentes. NO modificar nada.

Diagnóstico de desorden (decide si la etapa refactor aplica):

- entry point gigante (muchas responsabilidades en un archivo);
- capas mezcladas (IO externa, presentación y lógica en el mismo lugar);
- secretos hardcodeados en el código;
- sin suite de tests (sin red de regresión);
- duplicación evidente.

Si hay desorden → etapa refactor. Si no → salto directo a la etapa cierre. El resultado del diagnóstico se reporta clasificado en los cinco buckets.

## ETAPA REFACTOR (solo si el diagnóstico la dispara)

Objetivo: reestructurar por capas preservando el comportamiento. Cada paso = un paquete autocontenido y funcional (el programa sigue arrancando tras cada uno), aprobado e implementado por separado.

### Orden de extracción (patrón validado)

1. **Config y helpers puros** (centralizar variables/constantes/defaults y utilidades sin IO).
2. **Servicios / IO externa** (integradores de terceros: APIs, clientes HTTP, binarios del sistema, archivos).
3. **Presentación / handlers** (enrutado y comandos; entry point queda delgado).
4. **Hardening de secretos** (secreto hardcodeado → env var obligatoria con fail-fast, `.env.example` con placeholders, loader real verificado con `grep load_dotenv`).
5. **Red mínima de regresión como baseline** (si no existía, este paso pasa a ser el PRIMERO, antes de cualquier refactor):
   - crear ÚNICAMENTE las pruebas mínimas necesarias para capturar el comportamiento observable actual (no una suite enorme: las rutas/acciones principales del programa, con mocks por dependencia externa y entorno aislado — patrón `tests/mocks/` + fixtures anti-red);
   - validar que ese baseline representa correctamente el comportamiento existente (correrlo contra los pasos reales del proyecto y ajustarlo hasta que refleje lo que hace hoy);
   - usar ese baseline como referencia durante TODO el refactor;
   - después de cada paquete de refactor, ejecutar las pruebas correspondientes y comparar contra el baseline;
   - cualquier cambio observable de comportamiento se reporta como HALLAZGO (nunca se asume como mejora).
6. Al final de la etapa: **docs y tests sync** (puede delegar a `repo-readme-changelog`).

Las capas son RESPONSABILIDADES, no carpetas fijas: la forma varía por stack (Python `handlers/services/utils`; Node `controllers/services/routes`; frontend `components/hooks/api`).

### Reglas de la etapa

- **Preservar comportamiento**: el refactor no introduce features ni cambia salida observable. Si la validación detecta cambio de comportamiento, se reporta como HALLAZGO (no se "aprovecha" para modificar el programa).
- **Sin red de regresión no hay refactor**: si no existe suite, el primer paquete es crearla (bajo aprobación). Nunca reestructurar código que no puede verificarse.
- Cada paquete lleva **riesgo etiquetado** (cosmético / medio / rompe-API) y su "done" verificable: tests verdes + arranque OK (smoke test, ver Validación) + `git diff` mínimo.
- La aprobación puede ser por paquete o del plan completo (decisión del usuario en la propuesta).

### Flujo de la etapa (aplicado por paquete)

**análisis → propuesta del paquete → solicitud de aprobación → implementación → validación → informe → DETENERSE** (y solicitar el siguiente paquete).

## Evaluación de transición

Al completar el refactor (o si nunca hizo falta), evaluar el proyecto con el checklist de cierre y PROPONER al usuario la etapa cierre ("¿cierro con docs + secret scan + commit/push, o lo dejamos aquí?"). Proyectos internos pueden querer detenerse tras el refactor: el cierre nunca se impone.

## ETAPA CIERRE

### Checklist dinámico (aplicar solo lo que el proyecto revele)

| Control | Se aplica si… | Qué verificar |
|---|---|---|
| Env vars | existe `.env`/`.env.example`/config module | tabla de variables sync con defaults reales; `.env` y cookies/sesiones en `.gitignore` |
| Mecanismo de carga | existe código que lee env vars | `load_dotenv()` real vs `os.environ` puro: documentar el mecanismo REAL, no la promesa |
| Container | existe `Dockerfile` | usuario no-root, `.dockerignore` sano, sin secretos en build, contexto mínimo |
| Dependencias | existe lockfile/manifest | versiones exactas en docs; equivalencias paquete↔import documentadas (ej. `python-telegram-bot` → `import telegram`) |
| Tests | existe suite (`pytest`, `jest`, …) | correrla como red de regresión tras cada cambio |
| Deploy/proxy/red | hay URLs, puertos, túneles, gateways | documentar puertos/URLs reales; verificar formato de ruta del proveedor |
| Git | siempre | remote real (`git remote -v`), URL de clone pública en docs si aplica, branch, cambios no commiteados |
| Secretos | siempre | escaneo de patrones en lo que se va a versionar |

### Documentación de cierre

Invocar la skill **`repo-readme-changelog`** (composición): perfiles técnico/descriptivo, SSOT, versiones exactas, bloques de instalación por SO, troubleshooting con mensajes literales, regeneración desde cero sin historial git. Además:

- El CHANGELOG cuenta la historia VERDADERA: hallazgo → refactor/fix → validación (sin entradas inventadas).
- Toda docu que describa un defecto se RE-SINCRONIZA cuando el defecto se corrige (tabla de env, troubleshooting, notas): al cerrar, la docu describe el estado final y el CHANGELOG conserva el trayecto.
- `.env.example` refleja los defaults reales post-cambios.

### Auditoría final de secretos (antes de cualquier commit)

- Escanear lo que se va a versionar: `git grep -nE "(ghp_|gsk_|AKIA|sk-[A-Za-z0-9]{20}|xox[bap]-|-----BEGIN|password\s*=|token\s*=)"` (adaptar patrones al proyecto).
- Verificar `.env`, cookies, sesiones y carpetas de archivos generados en `.gitignore` Y que no estén en el staging (`git ls-files`).
- `git diff --check` y `git status` limpio salvo lo intencional. `git add` selectivo, nunca `git add -A` a ciegas.

## Validación de arranque (smoke test, compartida por ambas etapas)

- Ejecutar cada servicio ejecutable documentado hasta la frontera de credenciales o red, con valores de prueba, en entorno aislado (venv/temp), capturando TODA la salida.
- **Auditar la URL/red, no solo el mensaje:** listar método + URL completa + status de cada petición HTTP.
- **Clasificar el fallo ANTES de concluir:** `401/403/400` de la API real = ESPERADO con credenciales falsas (fin normal); `404`, `405`, `502`, redirects o URL malformada = ANÓMALO → sospechar del default de una variable de entorno (rompe también con credenciales válidas), no del token ni del usuario.
- **Causa raíz con segunda prueba:** validar la hipótesis independientemente (petición directa al endpoint, inspección del código de la librería instalada, comparación con el endpoint oficial). La primera explicación plausible se rechaza si la evidencia la contradice — incluidos cambios ya aprobados: si la validación desmiente un cambio implementado, se reporta y se corrige bajo nueva aprobación.
- **Fix con formato verificado:** si un default apunta a un gateway/proxy de terceros, verificar su formato de ruta real ANTES de escribir la solución (p. ej. el `:` interno de ciertos tokens rompe el parseo de URL del cliente si el path no lleva prefijo alfabético). Si no es verificable, declarar la incertidumbre.
- **Clasificación de arranque en el informe:** "verificado hasta la frontera de red" (fail-fast OK, red no comprobada) vs "arranque completo verificado". El fracaso en la frontera de red NO es verificación plena.

## Commit y push (aprobaciones independientes, último paso del cierre)

- **Commit:** solo tras aprobación explícita. Revisar `git diff --stat` y `git status` antes; mensaje convencional descriptivo (tipo + qué + por qué) coherente con el estilo del repo; NUNCA secretos; sin `-i`, sin amend de commits ajenos, sin force-push.
- **Push:** aprobación explícita INDEPENDIENTE. Verificar el remote y el mecanismo de autenticación real (SSH vs HTTPS con credenciales guardadas) ANTES de prometer el push; si el método activo falla, reportarlo y proponer la alternativa sin modificar config del repo sin permiso. Reportar el commit/ref final y confirmar el resultado.

## Controles que NO aplican

Sin Dockerfile → no hay hardening de contenedor. Sin suite → se propone crear la red de regresión como primer paquete del refactor (si se aprueba), nunca se impone. Sin backend → perfil descriptivo en docs, la "validación" es de contenido. Sin remote → el push no aplica y así se declara.

## Cuando no usar esta skill

Documentación por sí sola (usar `repo-readme-changelog`), features nuevas o lógica de negocio nueva, proyectos desde cero (esta skill asume proyecto existente y funcional), o cuando el usuario pida "haz todo automáticamente" — incluso entonces el commit y el push requerirán confirmación punto a punto.