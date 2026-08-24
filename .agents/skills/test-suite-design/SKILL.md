---
name: test-suite-design
description: Design, review, or refactor automated test suites for confidence, reliability, and maintainability. Use when deciding what to test, choosing test levels and boundaries, using mocks, writing assertions, structuring tests, handling flakes, or evaluating coverage.
---

# Test Suite Design

Build the smallest trustworthy suite that shows whether the system keeps its promises to its users. Optimize for confidence, useful failures, and sustainable cost, not test count or coverage percentage.

## 1. Start with intention and risk

1. Identify the user of the code, whether a person, developer, or another system.
2. State the intended behavior in terms that the user can observe.
3. Prioritize critical workflows, costly failures, regressions, error paths, and boundary cases.
4. Turn the steps a user would take to verify the behavior manually into an automated workflow.
5. Ask, "When will this test fail?" A trustworthy test fails if and only if the intended behavior is broken. Prove that it can fail before trusting it.

Do not test code merely because it exists. Test behavior whose failure matters.

## 2. Choose the right boundary

Treat every test as setup, action, and assertion. The boundary determines which parts of the system can affect its result.

* Keep collaborators real when their integration contributes useful confidence.
* Replace factors that are irrelevant to the intention, outside the system's responsibility, or nondeterministic, such as external service availability, clocks, or random values.
* When a substitute is needed, prefer stable system boundaries, such as HTTP, over internal collaborators. Keep as much real code inside the boundary as practical.
* Keep a dependency real when that integration is itself the behavior under test, especially in end to end tests.
* Run code in its production environment when the environment affects behavior. Test browser code in a real browser.

For UI tests, the network usually belongs to setup, and requests are implementation means rather than expected outcomes. Configure the server behavior, let invalid requests produce realistic failures, and assert what the user sees. Test network contracts separately when the contract itself is the intention.

## 3. Match the test level to the risk

Use a mix rather than a fixed ratio:

* Static analysis catches syntax, type, and convention errors cheaply.
* Unit tests cover pure logic and combinatorial edge cases precisely.
* Integration tests should carry much of the suite because they balance realistic confidence with speed and diagnosis.
* End to end tests cover a small set of critical user workflows that lower levels cannot prove.

Prefer the highest realistic level that gives valuable confidence at acceptable cost. Move cases lower when exhaustive coverage would make a higher level slow or fragile. Do not repeat the same confidence at every level.

## 4. Write behavior focused tests

* Keep every test isolated, deterministic, order independent, and responsible for its own state.
* Keep tests flat and self contained. Avoid nested hooks and shared mutable variables that hide prerequisites.
* Use one arrange phase and as many actions and assertions as one coherent workflow requires. Split genuinely distinct workflows, not individual assertions.
* Name the behavior and conditions, not implementation mechanics.
* Prefer user actions, public APIs, accessible queries, and observable outcomes over internal state, private methods, call order, or component structure.
* Wait for observable states, never arbitrary sleeps. For asynchronous absence, prove the unwanted state cannot occur before the test completes.
* Rely on implicit assertions and choose the assertion that produces the most useful failure. Remove redundant checks.
* Keep snapshots small, focused, stable, and clearly tied to an intention. Prefer explicit assertions when they communicate the behavior better.

## 5. Keep test code boring

Clarity is more valuable than cleverness.

* Inline setup while the scenario remains easy to read.
* Apply AHA (Avoid Hasty Abstraction). Extract factories or helpers only when repeated setup obscures the meaningful differences between tests.
* Make defaults valid and differences obvious. Do not hide actions or expectations behind elaborate test frameworks.
* Guarantee cleanup even when assertions fail. Prefer utilities that own and dispose of the resources they create.
* Treat disproportionately complex setup as feedback about missing test utilities or questionable production design. Do not distort a production API solely for tests.

## 6. Protect trust in the suite

* A flaky test makes every result suspect. Quarantine or skip it immediately, record what is known, then investigate, fix, rewrite, or delete it.
* Treat coverage as a diagnostic for missed branches or dead code, never as proof of quality. Do not let a percentage choose what to test.
* Remove tests that assert implementation details, duplicate existing confidence, or cannot catch a meaningful failure.
* Keep failure messages actionable. A failure should identify a broken behavior or a broken test boundary, not invite a blind snapshot update or retry.

## Review questions

1. Which user promise and risk does this test cover?
2. Would it survive a behavior preserving refactor?
3. Would it fail if the behavior actually broke?
4. Can anything unrelated to that behavior make it fail?
5. Is the boundary realistic without being wasteful?
6. Are setup, actions, and outcomes visible in one place?
7. Does this test add confidence that the suite does not already provide?
8. Can the team trust and diagnose it on every run?

## Sources

This skill distills Kent C. Dodds's guidance on [implementation details](https://kentcdodds.com/blog/testing-implementation-details), [the Testing Trophy](https://kentcdodds.com/blog/static-vs-unit-vs-integration-vs-e2e-tests), [workflow shaped tests](https://kentcdodds.com/blog/write-fewer-longer-tests), and [AHA testing](https://kentcdodds.com/blog/aha-testing), together with Artem Zakharchenko's guidance on [testing intention](https://www.epicweb.dev/the-true-purpose-of-testing), [the Golden Rule of Assertions](https://www.epicweb.dev/the-golden-rule-of-assertions), [test boundaries](https://www.epicweb.dev/what-is-a-test-boundary), [user focused network testing](https://www.epicweb.dev/do-not-assert-on-requests), and [flaky tests](https://www.epicweb.dev/be-smart-about-flaky-tests).
