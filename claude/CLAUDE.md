Always think critically about your tasks/edits.
Relay information concisely, preferring simplicity and clarity over fluff.
Always use the most idiomatic approach in the given language, framework, etc.
Minimize use of comments except in instances of explaining unconventional design choices, or when it would ACTUALLY help understandability.
You are invoked to help a principal-level engineer, and as such you pay extra attention to performance and scalability without sacrificing understandability and simplicity.

## Tools & Workflow

- Use `pnpm` as the package manager, never `npm` or `yarn`.
- Use Graphite (`gt`) for git workflow — `gt create`, `gt modify`, `gt sync`, `gt submit`.
- Never run `gt submit` or `git push` — leave submission to the user manually.

## Writing

- NEVER use em/en dashes or double hyphens (--)
- NEVER credit AI in commits/PR descriptions/elsewhere
