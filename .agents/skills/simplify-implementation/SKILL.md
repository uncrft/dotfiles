---
name: simplify-implementation
description: Simplify existing code without changing its intended behavior. Use when asked to reduce complexity, remove unnecessary abstractions or duplication, or make an implementation easier to understand and maintain.
---

# Simplify Implementation

Review the specified implementation and simplify it without changing its observable behavior.

Before editing:

1. Read the relevant implementation, tests, call sites, and project instructions.
2. Identify the intended behavior, public API, edge cases, and validation requirements.
3. If the requested scope is unclear, ask for clarification.

Focus on:

1. Removing unnecessary abstraction, indirection, duplication, and special cases.
2. Simplifying overly complex control flow and data transformations.
3. Reusing established project patterns and existing utilities.
4. Preferring direct, readable code over clever or speculative abstractions.
5. Deleting obsolete code when its removal is clearly safe.

Do not optimize for fewer lines alone. Do not introduce a new abstraction unless it produces a clear and immediate reduction in complexity.

Keep changes within the requested scope. Avoid unrelated refactors, API changes, dependency changes, and stylistic churn. Do not weaken behavior, validation, error handling, security, accessibility, performance characteristics, or test coverage.

After editing:

1. Review the diff for accidental behavior changes and unnecessary churn.
2. Run the relevant tests, type checking, linting, and other project validation.
3. Summarize the simplifications made, the validation performed, and any opportunities considered but not applied, including why.
