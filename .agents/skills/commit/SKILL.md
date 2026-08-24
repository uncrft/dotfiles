---
name: commit
description: Author conventional commits from the current diff and create them only after approval. Use when the user asks to commit changes, prepare a commit message, or split changes into commits.
---

# Conventional Commit Author

Treat any arguments supplied when invoking this skill as additional instructions.

1. Inspect the staged diff, or the working tree if nothing is staged.
2. Decide whether the change is one commit or should be split.
3. If splitting, propose the split and confirm with the question tool before proceeding.
4. Write the commit message or messages and confirm with the question tool.
5. Create the commit only after the user approves the wording.

## Grounding rules

Use the code diff and prior discussion as source of truth. Infer intent only when directly supported by file changes, naming, tests, or conversation. Do not claim motivation or impact not supported by context. If motivation is unclear, ask with the question tool.

## Detecting splits

Split when the diff mixes unrelated concerns: feature with refactor, formatting with behavioral changes, renames with logic changes, unrelated fixes in different areas. When splitting, describe each proposed commit with its header, files, and a one sentence rationale. Confirm the split with the user before creating any commits.

## Format

```text
<type>(<scope>): <subject>

<body>
```

Critical requirements:

* subject line in imperative mood, no trailing period, maximum 72 characters
* body is required, lines wrapped at 100 characters, explain what changed and why when supported by context
* use the smallest accurate scope from the files changed

Example:

```text
fix(auth): handle expired session tokens

Refresh the token check before redirecting to login so expired sessions do not leave the UI in a loading state. Update the guard and its tests to treat missing and expired tokens the same way.
```

## Writing style

Be concise. Favor prose over bullets. Follow ASD-STE100 Simplified Technical English guidelines. Do not use em dashes or hyphens as sentence separators. Stick to facts.

## Creating the commit

```bash
git commit -m "feat(search): add keyboard shortcut for focus" -m "Bind the slash key at the app shell level and ignore events from text inputs."
```

Do not create any commit until the user confirms the message.
