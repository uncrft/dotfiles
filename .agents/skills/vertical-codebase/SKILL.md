---
name: vertical-codebase
description: Structure code by domain, not by technical type. Apply when creating new files, components, hooks, utilities, types, or constants to ensure they land in the correct domain vertical rather than a horizontal type-based directory.
---

# Vertical Codebase

## When to use

Apply when creating new files, components, hooks, utilities, types, or constants. Before placing a file, ask: "what does this code do?" not "what is this code technically?"

## Core principles

1. **Group by domain, not by type.** Never create or perpetuate `components/`, `hooks/`, `utils/`, `types/`, `constants/` directories that group unrelated code by technical category. Instead, place code in the domain it belongs to (e.g. `src/widgets/`, `src/profiling/`, `src/dashboard/`).

2. **Colocate aggressively.** Props, types, helpers, constants, and tests that serve a single domain belong inside that domain's directory. A widget's query options live next to the widget, not in a distant `utils/` folder.

3. **Inline types next to usage.** Export types from the file that defines the thing they describe. Do not create standalone `types/` directories.

4. **No barrel files for internal use.** `index.ts` barrel files are reserved exclusively for package entry points (the public API surface exposed via `package.json` `exports`). Within a domain's internal structure, import directly from the source file. This keeps dependency graphs explicit and avoids circular imports.

5. **Shared code becomes its own vertical.** When code is consumed by multiple domains, promote it to its own domain directory (e.g. `src/page-filters/`). It does not need to be a "feature" to deserve its own vertical.

6. **Routes hint at verticals.** Pages and routes are a natural starting point for choosing domain boundaries. A `/dashboard` route maps to `src/dashboard/`.

7. **Low coupling, high cohesion.** Each vertical should be as self-contained as possible. Imports across verticals should be intentional and minimal.

## Choosing the right vertical

- Start from what the code *does* for the user or system, not what it *is* technically.
- If a piece of code only serves one domain, it lives in that domain.
- If it serves multiple domains, it becomes its own vertical.
- Align with team ownership where applicable (the billing team's code lives in `src/billing/`).

## Anti-patterns to avoid

- `src/components/widget.tsx` + `src/utils/widget.ts` + `src/types/widget.ts` (horizontal split)
- A `utils/` folder with 50+ unrelated files
- Deep import paths into another domain's internals
- Barrel files (`index.ts`) used within a domain just for convenience
