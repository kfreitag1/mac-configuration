---
name: pr-description
description: Generate a PR description based on the commits in your branch. Use when the user wants to create or update a pull request description, needs help documenting changes, or is preparing a PR for review.
allowed-tools: Bash(git status) Bash(git log:*) Bash(git diff:*) Bash(gt log:*) Bash(gh pr edit:*) Bash(pnpm preview-url) Bash(pnpm preview-url --storybook) Bash(pnpm tsx scripts/generateStorybookLinks.ts)
metadata:
  model: opus
---

1. If the branch is on `main` (trunk), with no unmerged commits, do nothing.
2. Based on the changes in the current branch, fill out the pull request template below.
3. **⚠️ IMPORTANT: ask if the user would like to post the description to the PR**

## Context

### Stacking

Devs often use Graphite stacks and will have branches stacked on top of main

#### Example

commit c45146 (HEAD -> top-of-stack, origin/top-of-stack)
commit 974255 (origin/bottom-of-stack, bottom-of-stack)
commit ecabd8 (origin/main, origin/HEAD, main) <-- trunk

### Get changes in branch

> In the example above we'd want the changes between `top-of-stack` and `bottom-of-stack`, excluding the changes in `bottom-of-stack`

**⚠️ IMPORTANT: Use `gt log -s` to understand the current stack**
**⚠️ IMPORTANT: Do NOT use `git diff main...HEAD` for stacked branches**
**⚠️ IMPORTANT: Do NOT include changes from parent branches, only include the current branch's changes.**

1. Use `git log --oneline main..HEAD` to see all commits in the stack
2. Identify which commits belong to the current branch vs parent branches
3. Use `git diff <first-commit-of-current-branch>^..<last-commit-of-current-branch>` to get only the current branch's changes
4. If the current branch has only one commit, use `git diff HEAD~1..HEAD`

Tip: Use `git log --graph --oneline -n 10` to visualize the branch structure if needed.

### Build preview URLs

- Preview URLs are constructed from the branch name
- Run `pnpm preview-url` to get the preview URL and obtain the auth url
- Run `pnpm preview-url --storybook` to get the Storybook preview URL
- In the "What URL(s) are affected?" table, replace `/path` with the provided tophat paths
  - If no tophat paths are provided, link to the home page, e.g. `[home](https://<(PROD|PREVIEW)_URL>)`

### Check for component changes and add Storybook links

1. Check if the git diff includes changes to component files in:

   - `src/components/base/`
   - `packages/brochure-kit/components/`
   - `src/components/shared/`

2. If component changes are detected:
   - Get the Storybook preview URL: `pnpm preview-url --storybook`
   - Get list of changed files from git diff
   - Generate Storybook table rows: `pnpm tsx scripts/generateStorybookLinks.ts <preview-storybook-url> <changed-files...>`
   - Add the rows to the Storybook table in the template

Example usage:

```bash
# Get preview URL
pnpm preview-url --storybook
# Output: https://brochure--branch-name.storybook.shopify.io

# Generate Storybook table rows with changed files
pnpm tsx scripts/generateStorybookLinks.ts https://brochure--branch-name.storybook.shopify.io \
  src/components/base/elements/Button/Button.tsx \
  packages/brochure-kit/components/Card/Card.tsx

# This will output the rows for the Storybook markdown table to include in the PR
```

### Post to Github

- Use `gh pr edit <branch-name> --repo "shop/world" --body "<PR_DESCRIPTION>"` if available
- If attempts to post to the PR fail, fallback to writing the description to a file

**⚠️ IMPORTANT: always use `--repo "shop/world"` with `gh pr edit`**

### Write to file

If posting to Github fails, write the description to a file at the root of the repo: `PR_DESCRIPTION_<TIMESTAMP>.md`

## Template

```
[//]: # (Here's some valuable docs for how to build & ship at Shopify)
[//]: # (Tophatting - https://vault.shopify.io/page/Tophatting~dhb9336.md)
[//]: # (WCAG - https://webaim.org/standards/wcag/WCAG2Checklist.pdf)
[//]: # (Do's & Don'ts - https://brochure-iii.docs.shopify.io/dos-donts)

[//]: # (Link to Github issue, if applicable. Prepend 'Closes ' to an issue URL to automatically close it when this PR is merged)

## Problem

[//]: # (What problem is being addressed? Alternatively, link to a GitHub issue)

## Solution

[//]: # (How does this solve the problem?)

## What could go wrong?

[//]: # (Anything to watch out for? Play devil's advocate.)

## What URL(s) are affected?

[//]: # (Replace PREVIEW_URL with the preview URL for the branch)
[//]: # (e.g. https://Shopify:Awesome@shopify-KEBAB-CASE-BRANCH-NAME.everest.shopify.com)

| Production Link              | PR Preview Link                                                                   |
| ---------------------------- | --------------------------------------------------------------------------------- |
| [/path](https://www.shopify.com/path) | [/path](PREVIEW_URL/path) |

[//]: # (Add this section only if component files were changed)
## Storybook Component Preview

[//]: # (List affected components with links to both production and preview Storybook)
[//]: # (Storybook URL: https://brochure.storybook.shopify.io)
[//]: # (Preview Storybook URL: from `pnpm preview-url --storybook`)

| Name | `base` | `brochure-kit` | Storybook | PR Preview Storybook |
| ---- | :----: | :------------: | :-------: | :------------------: |
| ComponentName | ✅ | - | [👀 View](https://brochure.storybook.shopify.io/?path=/story/component-path--default) | [👀 View](PREVIEW_STORYBOOK_URL/?path=/story/component-path--default) |

## Tophatting

These changes can be tophatted by:

[//]: # (REQUIRED)
[//]: # (Please describe how to test and tophat this work)
```
