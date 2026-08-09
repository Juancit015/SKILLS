---
name: ui-design-audit
description: Audit web interfaces for generic AI-generated UI patterns, weak product-specific visual language, missing states, weak hierarchy, and untestable design decisions. Use when reviewing, generating, or refactoring a website or app UI.
---

# UI Design Audit

## Purpose

Act as a rigorous UI/UX design reviewer before approving an AI-generated interface.

The goal is **not** to detect whether AI literally wrote the code. The goal is to detect whether the resulting interface is visually and behaviorally generic, interchangeable, underspecified, or disconnected from the product.

A generic interface can be clean and functional. Treat genericity as a product-design problem, not as a reason to ban rounded cards, gradients, Tailwind, component libraries, or any individual visual technique.

## Core principle

Evaluate **correspondence**:

> Does each important interface decision communicate something specific about this product, its users, their task, or the consequences of their actions?

Use the substitution test:

- Could this interface become a CRM, analytics app, finance app, or content planner by changing only nouns?
- Could the cards move to another page without changing the hierarchy?
- Would the UI remain almost identical with different data?
- Does an empty state merely say "No data yet"?

If yes, identify the missing product decision instead of blindly restyling the interface.

## Audit workflow

### 1. Identify the product job

Determine:

- Exact user.
- Context or moment of use.
- Primary task.
- Decision the user must make.
- Consequence or importance of that decision.
- Most important information on the screen.

If these cannot be identified from the product brief or code/content, mark the audit as **underspecified**.

### 2. Inspect visual hierarchy

Check whether the viewport has a clearly dominant element tied to the primary task.

Look for:

- Equal-weight cards.
- Generic 3-column feature grids.
- Centered hero + CTA + card grid used without product justification.
- Excessive whitespace hiding weak information architecture.
- Headlines that are visually dominant but operationally irrelevant.
- Important information receiving the same treatment as secondary information.

Do not prescribe a fixed layout. A real workflow may require a table, queue, timeline, map, canvas, split view, form, or dense operational layout.

### 3. Inspect content realism

Reject placeholder-shaped content as evidence of a finished design.

Test with:

- Long names.
- Long labels.
- Large and small numbers.
- Missing values.
- Warnings.
- Different statuses.
- Permissions.
- Multiple actions with different consequences.
- Empty datasets.
- Error messages.
- Realistic copy.

Content is part of the design system because it determines wrapping, density, hierarchy, column width, and component choice.

### 4. Inspect visual tokens and their rules

Do not judge isolated values only.

Audit:

- Color roles.
- Typography hierarchy.
- Font roles.
- Spacing scale.
- Border radius.
- Borders.
- Shadows.
- Icon treatment.
- Surface hierarchy.
- Contrast.
- Interactive states.

Ask:

- Does each token have a reason to exist?
- Is accent color overused?
- Does every card receive the same border/radius/shadow treatment?
- Is radius differentiated between controls, cards, containers, and decorative elements?
- Does typography distinguish data, labels, headings, warnings, and actions?
- Is color assigned semantic roles such as risk, success, warning, or selection?

### 5. Detect generic AI visual patterns

Flag combinations, not isolated properties.

#### High-signal patterns

- Rounded cards everywhere.
- Repeated cards with identical structure.
- Bright blue/purple accent on a neutral canvas without product justification.
- Soft gradients used as decoration rather than meaning.
- Generic dashboard sidebar + header + metric cards + chart.
- Fake metrics and interchangeable charts.
- Generic SaaS copy.
- Icon inside a colored circular container for every feature.
- Excessive pill-shaped controls.
- Uniform shadows on every surface.
- Every section centered and evenly spaced.
- Decorative glassmorphism without functional purpose.
- Stock-looking hero illustrations unrelated to the product.
- Identical visual treatment across semantically different components.

Important: never declare a UI generic because of one item. Evaluate the **pattern density and lack of product correspondence**.

### 6. Audit component states

A product interface is not only its happy path.

Check for:

- Loading.
- Empty.
- Error.
- Success.
- Permission denied / locked.
- Disabled.
- Hover.
- Focus.
- Active/selected.
- Validation errors.
- Long content.
- Offline or failed network where applicable.
- Mobile behavior.
- Reduced-motion behavior when motion exists.

Missing states are a strong indicator that the interface was optimized for a screenshot rather than a real product.

### 7. Audit responsive behavior

Do not accept "responsive" as a claim.

Verify or infer rules for:

- Navigation collapse.
- Grid changes.
- Tables.
- Long labels.
- Buttons.
- Forms.
- Typography.
- Images.
- Horizontal overflow.
- Touch targets.
- Mobile priority.

Ask what must remain visible on mobile and what can be deprioritized.

### 8. Audit interaction and motion

Motion must communicate product behavior.

Check:

- What happens on hover?
- What receives keyboard focus?
- What changes after an action?
- Are transitions meaningful or merely decorative?
- Are destructive/irreversible actions visually distinct?
- Does reduced motion have an intentional behavior?

Do not add animation simply to make a generic interface feel "premium".

### 9. Audit acceptance criteria

Replace subjective requirements such as:

- "Make it premium."
- "Make it modern."
- "Make it beautiful."

with measurable checks.

Examples:

- At 1440px, the primary workflow is visible without unnecessary scrolling.
- Only risk-related elements use the risk color.
- Every interactive row action is keyboard reachable.
- On mobile, the primary identifier and status remain visible.
- Long labels wrap without breaking the layout.
- Empty and error states explain what happened and what the user can do next.

Every important design decision should have a pass/fail test.

## Severity model

Use:

- **CRITICAL** — prevents the interface from communicating or supporting the core workflow.
- **HIGH** — strongly contributes to genericity, hierarchy failure, or broken real-world behavior.
- **MEDIUM** — weakens specificity, consistency, accessibility, or interaction quality.
- **LOW** — polish issue with limited product impact.
- **INFO** — observation or opportunity, not necessarily a defect.

## Audit output

When asked to audit a UI, produce:

### 1. Verdict

- Product specificity: `0-10`
- Visual hierarchy: `0-10`
- Design-system coherence: `0-10`
- Real-content robustness: `0-10`
- State completeness: `0-10`
- Responsive readiness: `0-10`
- Interaction quality: `0-10`
- Acceptance-test quality: `0-10`

Then provide:

- Generic UI risk: Low / Medium / High / Critical
- Short explanation.

### 2. Findings

For each issue:

```text
[SEVERITY] Finding
Evidence:
Why it matters:
Recommended change:
Acceptance test:
```

### 3. Genericity signals

Separate:

- Visual signals.
- Content signals.
- UX/state signals.
- Product-brief signals.

Do not confuse a symptom with its root cause.

Example:

```text
Symptom: three identical rounded cards dominate the page.
Root cause: the brief never declared which decision matters most.
Fix: define the primary workflow and redesign hierarchy around it.
```

### 4. Preserve what works

Explicitly identify:

- Strong product-specific decisions.
- Useful hierarchy.
- Good interaction patterns.
- Visual tokens worth keeping.
- Components that should not be unnecessarily redesigned.

Avoid "rewrite everything" recommendations.

### 5. Prioritized remediation

Give the smallest useful sequence:

1. Fix missing product decisions.
2. Fix hierarchy/composition.
3. Replace placeholder content with realistic content.
4. Define token usage rules.
5. Implement missing states.
6. Define responsive behavior.
7. Add measurable acceptance tests.
8. Apply visual polish last.

## Rules for AI-generated websites

When generating or modifying UI:

- Do not default to a dashboard merely because the project is SaaS.
- Do not create a card for every piece of information.
- Do not use gradients as a substitute for visual identity.
- Do not make every component rounded to the same radius.
- Do not make every section symmetrical when the workflow is asymmetric.
- Do not invent fake metrics when realistic data is available.
- Do not use placeholder copy if real product copy is known.
- Do not hide missing states.
- Do not call a design "premium" without concrete visual rules.
- Do not add visual noise solely to differentiate the design.
- Do not destroy useful existing design decisions merely to make the interface look different.

## Anti-pattern: adjective stacking

Treat prompts like:

> modern, premium, clean, elegant, futuristic, minimal, beautiful

as insufficient design specifications.

Convert adjectives into decisions:

- Typography → exact family/roles/weights.
- Color → semantic roles and usage limits.
- Spacing → scale and density.
- Radius → component-specific rules.
- Composition → dominant element and information order.
- Motion → purpose, trigger, duration, reduced-motion behavior.
- States → loading/empty/error/etc.
- Responsive → explicit priority changes.
- Acceptance → measurable pass/fail criteria.

## Root-cause rule

Before changing the model, framework, component library, or entire design, determine whether the brief left a decision unresolved.

A different AI model can produce a different surface while preserving the same ambiguity.

The preferred intervention is:

> Diagnose the missing decision → define it → change the smallest relevant part → verify with an acceptance test.

## Source basis

This skill incorporates the framework from v-1.design's "Why AI-Built Apps Look the Same: 7 Generic UI Patterns", especially its seven diagnostic areas:

1. Product job/category.
2. Realistic content.
3. Composition priority.
4. Visual token rules.
5. Component states and motion.
6. Operationally useful references.
7. Acceptance tests.

It also incorporates the site's guidance that generic UI is primarily a correspondence problem rather than a single CSS problem.

Source:
https://v-1.design/blog/why-ai-built-apps-look-the-same

Use external design/accessibility documentation when a specific technical claim needs verification. Do not present this skill as an authoritative detector of AI authorship; it audits interface quality and genericity.
