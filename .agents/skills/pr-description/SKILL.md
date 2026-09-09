---
name: pr-description
description: Author or revise a pull request description grounded in the actual code changes and repository template. Use when the user asks to write, improve, or rewrite a PR description or body.
---

# Pull Request Description

When invoked with a base-branch argument, use it as the comparison base for inspecting the changes.

1. Inspect the branch, commit history, diff, and changed files against the comparison base.
2. Read the PR template from `.github` at the repository root when present, typically `PULL_REQUEST_TEMPLATE.md` or `pull_request_template.md`.
3. If missing motivation or impact would materially change the description, ask the user before writing. Otherwise, omit uncertain claims.
4. Fill the template, remove irrelevant sections, and keep remaining sections brief.
5. Return the description as Markdown, ready to paste into the PR body.

## Grounding rules

Stick to facts from the code diff, commit history, and prior discussion. Do not claim intent, performance improvements, or business motivation unless explicit in context. When in doubt, say less.

## Template handling

Use the repository's actual PR template. Keep only relevant sections. Remove empty or speculative sections entirely. If the template asks for unavailable information, omit that section or ask the user. Without a template, write a short summary and include testing, migration steps, or caveats only when relevant and supported by evidence.

## Writing style

Write concise prose, conversational but professional. Favor paragraphs over bullet lists. Follow ASD-STE100 Simplified Technical English guidelines. Do not use em dashes or hyphens as sentence separators.

Lead with what changes for users and why, when that motivation is known. Include implementation details only when they help a reviewer understand the change. Report tests as passed only when their results have been verified.

Use GitHub alerts (`[!NOTE]`, `[!TIP]`, `[!IMPORTANT]`, `[!WARNING]`, `[!CAUTION]`) in the body where relevant to highlight migration steps, breaking changes, or caveats.

Body example:

```text
This changes the session timeout flow in the dashboard settings page. The form now persists the selected timeout value as minutes and rehydrates it correctly when the page reloads.

On the implementation side, the settings mapper now normalizes null values before validation, and the submit handler only sends fields that actually changed.
```
