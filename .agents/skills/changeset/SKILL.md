---
name: changeset
description: Author a changeset file focused on user facing impact. Use when the user asks to create or write a changeset, optionally scoped to a named package.
---

# Changeset Author

When invoked with an argument, treat it as the package name and scope the investigation to that package.

1. Inspect the relevant diff and changed files, scoped to the supplied package when present.
2. Identify the user facing effect of the change.
3. If the motivation is not obvious from the diff or prior discussion, ask with the question tool before writing.
4. Write the changeset in the exact format below.
5. Re-read the file and verify the format before finishing.

## Grounding rules

Treat the code diff and prior discussion as the source of truth. Do not invent motivation, performance claims, or implementation rationale unless they are explicit in context.

Focus on what matters to users: new or removed behavior, API changes, configuration changes, migration requirements, changed defaults. Prefer "Add support for configuring retry delay per webhook" over "Refactor the retry scheduler to use a shared utility" unless the refactor changes externally visible behavior.

## Exact format

````md
---
"package-name": minor
---

Add retry delay configuration for webhooks

Users can now set a retry delay per webhook instead of relying on the global default. This is useful when a destination needs a longer cooldown after failures.

To migrate, add `retryDelayMs` to the webhook configuration you want to override.

```ts
createWebhook({
  url: endpoint,
  retryDelayMs: 5000,
});
```
````

Rules:

* front matter first, then a concise title with no trailing period, then a blank line, then prose description
* include migration notes and code examples when relevant
* avoid filler like "This PR" or "This changeset", start directly with the change

## Writing style

Be concise. Favor prose over bullet points. Use a conversational yet professional tone. Follow ASD-STE100 Simplified Technical English guidelines. Do not use em dashes or hyphens as sentence separators. Stick to facts.

## Examples

Good:

```md
---
"@acme/client": patch
---
Fix timeout handling for streaming requests

Streaming requests now respect the configured timeout instead of staying open until the server closes the connection. If you relied on the old behavior for long running streams, increase the timeout in the client configuration.
```

Bad:

```md
---
"@acme/client": patch
---

Updated timeout handling.

Refactored the request pipeline and touched several files.
```

The bad example ends the title with a period, focuses on implementation, and does not help users understand whether they need to act.
