---
name: vitest-conventions
description: "Vitest test authoring conventions: mocking patterns, test structure, and assertion style. Use when writing or reviewing vitest tests."
---

# Vitest Test Authoring Conventions

Use when writing or reviewing vitest tests in this repository.

## Test scope

Tests must follow Kent C. Dodds's [Write fewer, longer tests](https://kentcdodds.com/blog/write-fewer-longer-tests) guidelines:

- Model each test around one complete user workflow, with one arrange phase and as many actions and assertions as that workflow requires.
- Prefer fewer, longer, fully isolated tests over splitting related assertions into separate test cases.
- Do not follow a one-assertion-per-test rule or create tests for individual implementation details when those checks belong to the same workflow.
- Keep genuinely distinct workflows, such as success and failure paths, in separate tests.
- Do not render the same component multiple times in one test unless rerendering is part of the behavior under test.

## Mocking

- **Auto-mock modules** with `vi.mock("module")` (no factory). Configure per-test via `vi.mocked(fn).mockReturnValue(...)`.
- **Node builtins** use `vi.mock("node:process", { spy: true })` to wrap real exports as spies.
- **Globals** (`fetch`, `console`) use `vi.stubGlobal`. Replace `console` entirely: `vi.stubGlobal("console", { error: vi.fn(), info: vi.fn() })`.
- **Partial types** use `fromPartial` from `@octopus-energy/vitest/utils` instead of `as any`.
- **No `vi.hoisted`** or manual mock variables. Import the real export, then `vi.mocked(realExport)` for setup.
- **Process exit**: import `{ exit } from "node:process"`, mock with `vi.mocked(exit).mockImplementation(() => { throw new Error("process.exit"); })`.

## Structure

- One top-level `beforeEach` for shared setup (env stubs, global mocks, default implementations).
- Scoped `beforeEach` inside `describe` only for per-suite state.
- No `afterEach` or manual `mockRestore()` calls; rely on vitest's automatic restore.
- Inline mock setup per test rather than shared helper functions; each test is self-documenting.

## Assertions

- Assert on real imports directly: `expect(fetch)`, `expect(console.error)`, `expect(get)`.
- `expect.stringContaining(...)` for error messages.
- Exact strings for known output.
- `expect.objectContaining` for partial object matching.
