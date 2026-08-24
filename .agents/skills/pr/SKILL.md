---
name: pr
description: Create a GitHub pull request with the gh CLI, grounded in the actual code changes and repository template. Use when the user asks to open, create, or draft a pull request.
---

# GitHub PR Creator

When invoked with an argument, treat it as the target base branch.

1. Inspect the branch, commit diff, and changed files.
2. Read the PR template from `.github` at the repository root, typically `PULL_REQUEST_TEMPLATE.md` or `pull_request_template.md`.
3. If motivation or impact is not obvious, ask with the question tool before writing.
4. Fill the template, remove irrelevant sections, and keep remaining sections brief.
5. Create the PR with `gh pr create`, targeting the supplied base branch when present.

## Grounding rules

Stick to facts from the code diff, commit history, and prior discussion. Do not claim intent, performance improvements, or business motivation unless explicit in context. When in doubt, say less.

## Template handling

Use the repository's actual PR template. Keep only relevant sections. Remove empty or speculative sections entirely. If the template asks for unavailable information, omit that section or ask the user.

## Writing style

Write concise prose, conversational but professional. Favor paragraphs over bullet lists. Follow ASD-STE100 Simplified Technical English guidelines. Do not use em dashes or hyphens as sentence separators.

The title should use conventional commit style: `fix(settings): validate empty timezone values`, not `updates` or `misc fixes`.

Use GitHub alerts (`[!NOTE]`, `[!TIP]`, `[!IMPORTANT]`, `[!WARNING]`, `[!CAUTION]`) in the body where relevant to highlight migration steps, breaking changes, or caveats.

Body example:

```text
This changes the session timeout flow in the dashboard settings page. The form now persists the selected timeout value as minutes and rehydrates it correctly when the page reloads.

On the implementation side, the settings mapper now normalizes null values before validation, and the submit handler only sends fields that actually changed.
```

## Command pattern

Use a heredoc to pass the body:

```bash
gh pr create --title "fix(settings): validate empty timezone values" --body "$(cat <<'EOF'
## Summary
...
EOF
)"
```

When a base branch was supplied, add `--base "<base-branch>"`.
