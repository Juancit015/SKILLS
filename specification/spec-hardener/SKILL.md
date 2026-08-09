---
name: spec-hardener
description: Convierte una propuesta, análisis o auditoría generada por IA (ChatGPT, DeepSeek, otro agente, incluyendo auditorías de skills como ui-design-audit) en un spec/prompt accionable con decisiones cerradas, sin ambigüedades ni placeholders sueltos. Úsala siempre que el usuario pegue el resultado de otro agente de IA (un análisis, una auditoría, una propuesta técnica) y quiera "actualizar el prompt", "incorporar esto", o simplemente comparta ese resultado esperando que se procese, no solo cuando lo pida explícitamente. También úsala cuando un brief/prompt existente tenga secciones marcadas como "opcional", "a evaluar", "pendiente de definir", TODOs, o frases vagas tipo "debe sentirse moderno/cálido/profesional" que no son verificables. Complementa (no reemplaza) skills de auditoría/generación como ui-design-audit o web-platform-design, ya que esta skill es para el lado de recibir y resolver ese feedback, no para producirlo. El objetivo es que cada iteración deje el documento más cerrado, nunca más abierto.
---

# Spec Hardener

Un spec (prompt para un agente de código, brief de diseño, especificación de producto) falla no por falta de ideas, sino por dejar demasiadas decisiones abiertas. Cada vuelta de feedback (de otro agente de IA, de un usuario, de una auditoría) debe **cerrar** algo, no solo añadir más texto. Esta skill captura el flujo para lograrlo, iteración tras iteración, sobre un único documento vivo.

## Relación con otras skills

Esta skill juega un rol distinto al de las skills que **auditan o generan** interfaces/código (por ejemplo `ui-design-audit`, que diagnostica patrones genéricos de UI, o `web-platform-design`, que diseña/rediseña plataformas). Esas producen el diagnóstico o el artefacto; `spec-hardener` es el paso de **procesar ese resultado y cerrarlo sobre el documento vivo** — no vuelve a auditar el diseño desde cero, ni genera código.

- Si el usuario pide "audita esta interfaz" o "revisa si este diseño es genérico" → esa es tarea de `ui-design-audit`, no de esta skill.
- Si el usuario pega el *resultado* de una auditoría (propia o de otro agente) y hay que decidir qué se resuelve, qué se pregunta y qué se defaultea sobre el spec → esta skill.
- No se solapa con `repo-readme-changelog` (esa documenta un repo ya construido); ni con `web-platform-design` (esa diseña/redisña la interfaz en sí). `spec-hardener` opera en la capa previa: el documento de especificación que guía a cualquiera de esas otras skills o a un agente de código.

## El documento vivo

Todo el trabajo converge en **un solo archivo** (el spec/prompt), que se edita in-place en cada turno — nunca se reescribe desde cero ni se generan versiones paralelas. Si no existe todavía, créalo la primera vez que el usuario traiga contenido sustancial que lo amerite (una propuesta larga, un análisis de otro agente, un conjunto de requisitos). Usa `create_file`/`str_replace` sobre ese archivo en cada turno posterior; nunca repitas todo el contenido en el chat cuando ya vive en el archivo.

## El bucle

Cuando llega contenido nuevo (una propuesta de otro agente, una auditoría, una corrección del usuario):

1. **Extrae los hallazgos/decisiones nuevas** — no lo copies tal cual al spec. Tradúcelo a cambios concretos sobre el documento existente.
2. **Clasifica cada punto abierto** (ver la tabla de triage abajo) en: hecho real que solo el usuario puede confirmar / decisión de diseño que tú puedes resolver con un default razonable / ambigüedad que cambia materialmente el producto.
3. **Resuelve lo que puedas resolver tú mismo** directamente en el documento, dejando registro explícito de la decisión y su razonamiento (no solo el resultado) en una sección de "Decisiones tomadas".
4. **Pregunta solo lo que de verdad lo amerita**, y hazlo con opciones concretas, no preguntas abiertas (ver más abajo).
5. **Vuelve a convertir cualquier intención vaga en un test verificable** (ver sección de tests).
6. **Actualiza el archivo**, no repitas todo el contenido en el chat — resume qué cambió y por qué.

Repite este bucle en cada turno. El documento debe estar progresivamente más cerrado; si una vuelta de feedback deja algo *más* ambiguo que antes, es una señal de que se aceptó contenido sin triage.

## Triage: ¿resolver, preguntar, o defaultear?

| Tipo de punto abierto | Qué hacer | Ejemplo |
|---|---|---|
| **Hecho real sobre el mundo/producto que solo el usuario o su equipo conoce** | Preguntar directamente, o marcar como pendiente explícito si no es bloqueante — nunca inventarlo | "¿Los datos del usuario se guardan en servidor o localmente?", nombres reales del equipo, URLs, licencias |
| **Decisión que cambia la dirección o identidad del producto** | Preguntar con opciones concretas (2-4 alternativas, no pregunta abierta) | Tono cálido vs. coherencia con la identidad visual existente; a quién le habla la página primero |
| **Detalle de implementación con impacto bajo/reversible** | Resolver tú mismo con un default razonable, y documentar el porqué | Radius de bordes, si se vendorizan librerías o se usan por CDN, copy exacto de un botón |
| **Afirmación de seguridad, privacidad, salud o legal** | Nunca asumir. Si no hay confirmación real, usar lenguaje que no afirme nada no verificado, y marcarlo como pendiente de validar — no rellenar con una frase genérica tranquilizadora | Copy de privacidad, límites éticos, disclaimers de salud mental |

Cuando la pregunta es necesaria, usa el patrón de opciones concretas (evita "¿qué opinas de X?"; ofrece 2-4 caminos claros con sus trade-offs). Si tienes una herramienta de preguntas con opciones estructuradas disponible, úsala; si no, ofrécelas igual en texto plano.

## Política de placeholders

Un placeholder (`TODO`, `[ajustar según...]`, `nombre pendiente`) es aceptable **en el documento de trabajo/interno**, nunca en lo que llegaría a producción o a manos de un tercero sin que el usuario lo note. Regla concreta a incluir en cualquier spec que produzcas: si al momento de entregar/publicar sigue habiendo un dato sin confirmar, la sección correspondiente se omite o se muestra en un estado neutro — no se publica el placeholder visible. Deja esta regla explícita en el propio documento, no solo en tu cabeza.

## Convertir intenciones en tests verificables

Frases como "debe sentirse profesional", "debe transmitir confianza", "no debe ser genérico" no son accionables — nadie puede verificar si se cumplieron. Por cada intención de este tipo en el spec, agrega:

- **Un test concreto y observable** (qué se mide o qué se le pregunta a quién).
- **Un validador** — quién lo ejecuta (el propio equipo como proxy es válido si no hay acceso a usuarios externos).
- **Un momento** — cuándo se ejecuta (antes de publicar, en review, etc.). Si no se puede ejecutar, márcalo `skipped — pendiente` en vez de borrarlo o dejarlo implícito.

Ejemplo de transformación:
> Vago: "El diseño no debe sentirse genérico."
> Test: "Si se reemplaza el elemento distintivo (nombre, avatar, color de marca) por uno genérico, ¿el resto del contenido sigue funcionando igual de bien para cualquier competidor? Si sí, falta diferenciación." Validador: el propio equipo. Momento: antes de implementar.

## Vigilar el riesgo de genericidad

Cuando el contenido describe un producto/marca específico, identifica explícitamente 2-3 "pilares de diferenciación" — elementos que un competidor genérico no podría replicar con solo cambiar el nombre (un asset único, un tono de copy muy específico del contexto real, una decisión de composición verificable). Si el spec no tiene ninguno declarado, es una señal para preguntar o proponerlos, no para dejarlo pasar.

## Al recibir una auditoría/feedback de otro agente

1. Triágalo por severidad si la trae (HIGH/MEDIUM/LOW) — resuelve HIGH primero.
2. Para cada hallazgo, decide con la tabla de triage si se resuelve, se pregunta, o se defaultea — no lo apliques literalmente sin pasar por el filtro (el otro agente puede proponer algo que contradiga una decisión humana ya tomada; en ese caso, señala el conflicto en vez de sobrescribir en silencio).
3. Actualiza el documento vivo con los cambios y dónde corresponda, deja constancia de qué decía antes y por qué cambió.
4. Si la auditoría dice "listo para implementar" o similar, resume brevemente qué se cerró en esta vuelta en vez de reabrir cosas ya resueltas — no generes trabajo innecesario re-litigando decisiones ya tomadas sin nueva información.

## Ejemplo de referencia

Un caso completo de este flujo aplicado (una propuesta de landing page para un proyecto de acompañamiento emocional, con tres rondas de auditoría de diseño de otro agente, resolviendo audiencia, diferenciación visual, copy de privacidad, y tests de aceptación) está disponible como ejemplo en `references/ejemplo-yue-companion.md`. Consúltalo si quieres ver el patrón aplicado de principio a fin, especialmente para calibrar qué tan detallada debe quedar una sección de "Decisiones tomadas" o una tabla de tests de aceptación.
