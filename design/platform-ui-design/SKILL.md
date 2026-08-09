---
name: web-platform-design
description: Design and redesign business web platforms end to end with one consistent UI system across dashboards, auth, navigation, forms, tables, CRUD flows, reports, modals, alerts, charts, settings, and dense admin screens, while preserving application logic and functionality.
---

# Web Platform Design

Use this skill when the user wants a web platform to feel like one product across all screens, especially ERP, CRM, admin, backoffice, or internal management apps.

## What To Optimize For

- one visual system across the entire app
- professional, restrained, commercially credible UI
- high density without visual noise
- strong hierarchy for navigation, data entry, and review
- light and dark themes designed independently
- consistency over page-by-page experimentation

## Core Approach

1. Read the existing app structure first.
2. Identify shared layouts, partials, and global styles.
3. Redesign the system from the top down: tokens, layout, navigation, cards, forms, tables, and feedback states.
4. Push visual rules into shared CSS and reusable components.
5. Touch page templates only when markup needs semantic hooks or inline styles must be removed.
6. Audit the whole app for mismatched component behavior and fix outliers.

## Scope Control

- For large applications, start with the shared shell, navigation, tokens, and the highest-traffic modules.
- Do not redesign every screen independently before establishing shared components.
- If the app has many modules, apply the system to one representative CRUD, one dashboard/report, and one form-heavy flow first, then propagate the pattern.

## Stack Signals

Inspect these files and patterns before choosing an implementation path:

- `package.json`, `vite.config.*`, `next.config.*`, `nuxt.config.*`, `astro.config.*`
- `tailwind.config.*`, `postcss.config.*`, `*.module.css`, `*.scss`, `*.sass`
- `composer.json`, `requirements.txt`, `pyproject.toml`, `Gemfile`, `pom.xml`
- layout files such as `base.html`, `layout.*`, `app.*`, `_app.*`, `root.*`
- UI library imports, CDN links, icon packages, Bootstrap classes, Tailwind utility classes
- existing design tokens, CSS variables, theme providers, dark-mode toggles

Respect the detected stack. Do not assume plain CSS if the project already uses Tailwind, component libraries, CSS modules, styled-components, or framework-level theming.

## Design Principles

- Prefer clarity, rhythm, and restraint over decorative styling.
- Use one typeface and one spacing scale everywhere.
- Keep card radii, button heights, input heights, and badge shapes consistent.
- Use subtle borders and shadows; avoid heavy glows and decorative gradients.
- Make cards, panels, and menus feel like part of the same system.
- Use semantic color only where it carries meaning.
- Ensure icon sizes, alignment, and spacing are uniform.
- Design dark mode as a real surface system, not an inverted light mode.
- If the project already has a stable design convention, preserve it unless the user explicitly asks for a redesign.

## Example Tokens

Use this level of granularity when a project does not already have design tokens:

```css
:root {
    --font-sans: "Inter", system-ui, sans-serif;
    --space-1: 4px;
    --space-2: 8px;
    --space-3: 12px;
    --space-4: 16px;
    --radius-sm: 6px;
    --radius-md: 8px;
    --control-height: 42px;
    --surface-1: #ffffff;
    --surface-2: #f8fafc;
    --border-color: #dde4ee;
    --text-primary: #172033;
    --text-muted: #64748b;
    --primary-color: #2563eb;
    --shadow-sm: 0 1px 2px rgba(15, 23, 42, 0.06);
}

[data-theme="dark"],
[data-bs-theme="dark"] {
    --surface-1: #161d27;
    --surface-2: #1c2531;
    --border-color: #2b3747;
    --text-primary: #edf3f8;
    --text-muted: #94a3b8;
    --primary-color: #60a5fa;
    --shadow-sm: 0 16px 32px rgba(0, 0, 0, 0.24);
}
```

## Component Rules

- Navigation: sidebar and navbar should share spacing, icon sizing, active states, and surface treatment.
- Cards: rely on background, border, and shadow only; avoid top borders and loud accents.
- Forms: use consistent label rhythm, control height, focus states, disabled states, and help text.
- Tables: keep readable headers, sticky structure where useful, consistent row density, and aligned actions. For tables that can grow large (audit logs, record lists), prefer pagination or virtualization over rendering everything at once, and keep row density tight enough to scan quickly without sacrificing legibility.
- Buttons: standardize sizes, corner radius, hover feedback, and icon placement.
- Badges: keep them compact and semantic.
- Modals and alerts: match the app surfaces and typography, not browser defaults.
- Charts and analytics: use the same palette, grid contrast, and empty-state treatment as the rest of the app.

## States: Loading, Empty, Error

Treat these as first-class components, not per-page afterthoughts:

- Define one loading pattern (skeleton, spinner, or progressive reveal) and reuse it across tables, cards, and charts — do not mix approaches.
- Empty states must say what happened and, when applicable, offer the next action (e.g. "No visits registered yet — Register the first one"), not just "No data."
- Error states must distinguish between "nothing to show" and "something failed" — these are different states with different visual treatment and different next actions.
- Charts and dashboards specifically: verify with realistic data (large numbers, zero, single data point, null/missing values) before calling a chart done. A chart styled only against clean demo data will visibly break on the first real edge case.
- Table pagination and search: define what the "no results for this filter" state looks like, distinct from "no data exists at all."

## Roles and Permissions in the UI

Business platforms almost always have more than one role (admin, supervisor, operator, viewer, etc.). Make the permission model visible, not just enforced server-side:

- Decide per action whether an unauthorized control is **hidden** or **visible-but-disabled** — pick one convention and apply it consistently across the app, don't mix both without reason.
- Disabled controls the user can't use should communicate why (tooltip, help text, or adjacent label), not just look inert.
- Use a consistent visual marker for role/permission level (badge, label, icon) rather than inventing a new treatment per screen.
- Destructive or irreversible actions (delete user, deactivate record) should be visually distinct from routine actions regardless of role, and should get a confirmation step.
- Audit or history views that show "who did what" should visually tie the action to the actor (avatar/initials, name, timestamp) consistently across every log entry.

## Accessibility Checklist

- Maintain visible focus states for keyboard navigation.
- Preserve readable contrast for text, borders, controls, charts, and disabled states.
- Keep touch targets large enough for common controls, especially navigation and row actions.
- Ensure modals, dialogs, toasts, and alerts have appropriate roles or `aria-*` attributes when markup is touched.
- Do not rely on color alone to communicate status; pair color with labels, icons, or text.

## Implementation Guidance

- Prefer changing shared files first, then the pages that expose inconsistencies.
- Replace inline styles with reusable classes and component variants.
- Define UI tokens for color, spacing, radius, shadow, and motion before styling individual screens.
- If the app uses Bootstrap or a similar system, override it intentionally instead of mixing multiple visual languages.
- Preserve behavior, routes, state, permissions, and data flow unless the user explicitly asks for functional changes.
- **Before renaming or removing any CSS class**, search the JS/templates for selectors that target it (`querySelector`, `getElementsByClassName`, event delegation by class, jQuery selectors, or class-based show/hide toggles). Renaming a class that's purely visual is safe; renaming one that JS also depends on will silently break behavior. When in doubt, add the new visual class alongside the old one instead of replacing it.

## Conflict Handling

- If the existing project has a documented design system, extend it instead of replacing it.
- If the user asks for a full redesign, prefer global tokens and shared components before individual page edits.
- If conventions conflict, follow the local convention used by the highest-level layout or component library.
- If a requested visual change would break usability, explain the tradeoff and choose the accessible implementation.

## Visual Audit Checklist

After the first pass, search for and eliminate:

- inline `style=`
- inconsistent shadows
- inconsistent border radii
- inconsistent button heights
- inconsistent input heights
- repeated gradients
- decorative top bars on cards
- mismatched icon sizing
- mismatched paddings and margins
- screens that look like they were designed in different eras

## When To Use This Skill

Use it for:

- ERP and admin dashboards
- CRMs and backoffice tools
- reporting and analytics panels
- authenticated business portals
- form-heavy, table-heavy, multi-module web apps

Keep the work practical: the result should feel like a polished commercial platform, not a decorative demo.

## When Not To Use This Skill

Do not use this skill as the primary guide for:

- public marketing landing pages
- editorial websites or portfolios
- one-off visual experiments
- brand identity exploration without an existing product UI
- game interfaces or highly illustrative experiences
