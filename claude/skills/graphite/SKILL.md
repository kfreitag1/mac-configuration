---
name: graphite
description: Comprehensive guide for using Graphite CLI (gt) for stacked diffs and branch management in the monorepo. Covers common workflows like creating branches, submitting PRs, syncing, and restacking.
---

# Graphite CLI Guide

Comprehensive guide for using Graphite CLI (`gt`) for managing stacked diffs and branches in the Shopify monorepo.

## When to Use This Skill

Use this skill when:
- **Creating new branches and commits**
- **Submitting pull requests**
- **Managing stacked changes**
- **Syncing with remote branches**
- **Resolving stack conflicts**
- **User asks about Graphite workflows**
- **Troubleshooting branch issues**

## What is Graphite?

Graphite is a tool for managing **stacked diffs** - a development workflow where you create multiple dependent branches that build on each other, instead of one large branch with all changes.

### Benefits of Stacking
- **Smaller, focused PRs** - Easier to review
- **Faster iteration** - Don't wait for one PR to merge before starting the next
- **Better organization** - Logical separation of concerns
- **Parallel work** - Multiple reviewers can work simultaneously

### Key Concepts

**Stack:** A series of branches where each branch builds on the previous one
```
main
  ↓
branch-1 (feat: add API)
  ↓
branch-2 (test: add tests)
  ↓
branch-3 (docs: update docs)
```

**Trunk:** The base branch (usually `main`) that all stacks build from

**Restack:** Update branches to include changes from their parent branches

## Core Graphite Commands

### 1. Creating Branches and Commits

#### `gt create` - Create a new branch with a commit

**Most common usage:**
```bash
# Stage your changes first
git add .

# Create branch with commit message
gt create --message "feat: add new feature"

# With AI-generated branch name and message
gt create --ai

# Create without opening editor
gt create -m "fix: resolve bug"
```

**Advanced options:**
```bash
# Stage all changes and create
gt create --all -m "refactor: improve performance"

# Insert branch between current and child (useful for splitting changes)
gt create --insert -m "test: add missing tests"

# Stage only some changes interactively
gt create --patch -m "style: update formatting"
```

**Key points:**
- Always `git add` files before running `gt create`
- Branch name is auto-generated from commit message
- If no message provided, opens editor
- Creates a new branch stacked on current branch

### 2. Submitting Pull Requests

#### `gt submit` - Create or update GitHub PRs for your stack

**Most common usage:**
```bash
# Submit current branch and all its ancestors (recommended)
gt submit --no-interactive

# Submit with browser view
gt submit --no-interactive --view

# Update existing PRs only (don't create new ones)
gt submit --update-only

# Submit entire stack (current + descendants)
gt submit --stack --no-interactive
```

**Interactive options:**
```bash
# AI-generate PR titles and descriptions (only for new PRs)
gt submit --ai

# Edit PR metadata in CLI
gt submit --edit

# Edit only descriptions
gt submit --edit-description

# Open web browser to edit metadata
gt submit --web
```

**Advanced options:**
```bash
# Create PRs as drafts
gt submit --draft

# Mark PRs as merge-when-ready
gt submit --merge-when-ready

# Rerequest review from reviewers
gt submit --rerequest-review

# Add comment to PR
gt submit --comment "Ready for review"
```

**Key points:**
- `--no-interactive` skips prompts (faster for automation)
- Submits current branch AND all ancestors (downstack)
- Use `--stack` to also submit descendants (upstack)
- Updates existing PRs automatically
- Always force-with-lease by default (safe)

### 3. Syncing with Remote

#### `gt sync` - Sync all branches with remote

**Most common usage:**
```bash
# Sync everything (trunk + all branches)
gt sync

# Sync without prompts
gt sync --force

# Sync across all trunks
gt sync --all
```

**What it does:**
- Pulls latest trunk (main) from remote
- Syncs all local branches with remote versions
- Prompts to delete merged/closed PR branches
- Restacks branches automatically
- Resolves conflicts if needed

**Key points:**
- Run this regularly (daily) to stay up to date
- Safe operation - prompts before destructive actions
- Use `--force` to skip confirmation prompts

#### `gt get` - Checkout teammate's stack

**Most common usage:**
```bash
# Get specific branch
gt get branch-name

# Get branch by PR number
gt get 240665

# Get current stack (if you're already on a branch)
gt get

# Force overwrite local changes
gt get branch-name --force
```

**What it does:**
- Fetches branch from remote
- Checks out the branch
- Syncs upstack branches if they exist locally
- Creates local tracking branch

**Key points:**
- Use this to review teammate's PRs
- `--downstack` to only sync the specific branch
- `--force` to overwrite local changes

### 4. Restacking Branches

#### `gt restack` - Rebase branches on their parents

**Most common usage:**
```bash
# Restack current stack (current + descendants)
gt restack

# Restack only current branch
gt restack --only

# Restack only ancestors (downstack)
gt restack --downstack

# Restack only descendants (upstack)
gt restack --upstack
```

**When to use:**
- After pulling latest main
- After modifying a parent branch
- When stack shows "needs restack"
- To resolve conflicts

**Key points:**
- Automatically triggered by `gt sync`
- Interactive rebase if conflicts occur
- Updates all affected branches

### 5. Branch Navigation

#### Quick navigation commands:

```bash
# Move down to parent branch
gt branch down
# Alias: gt bd

# Move up to child branch
gt branch up
# Alias: gt bu

# Jump to bottom of stack (closest to trunk)
gt branch bottom
# Alias: gt branch b

# Jump to top of stack
gt branch top
# Alias: gt branch t

# Checkout specific branch (with interactive selector)
gt branch checkout
# Alias: gt branch co
```

### 6. Branch Management

#### `gt branch` commands:

```bash
# Create new branch (same as gt create)
gt branch create -m "feat: new feature"

# Delete branch (safe - prompts if not merged)
gt branch delete branch-name

# Rename current branch
gt branch rename new-name

# Show branch info
gt branch info

# Edit branch commits (interactive rebase)
gt branch edit

# Fold branch into parent (combine branches)
gt branch fold
```

### 7. Viewing Your Stack

#### `gt log` - View your branch stack

```bash
# View all branches (default)
gt log

# View current stack only
gt log --stack

# View in reverse order (bottom to top)
gt log --reverse

# Limit depth
gt log --steps 3

# Show untracked branches too
gt log --show-untracked
```

**Aliases:**
- `gt ls` - Short log (default)
- `gt ll` - Long log (detailed git graph)

**Example output:**
```
◉ my-feature-branch (current)
│ 2 hours ago
│ PR #12345 (Open)
│ feat: add new feature
│
◯ my-base-branch
│ 1 day ago
│ PR #12344 (Approved)
│ refactor: improve code
│
◯ main
```

### 8. State and Status

#### `gt state` - View Graphite state

```bash
# Show current state
gt state
```

Shows:
- Current branch
- Stack information
- PR status
- Sync status

## Common Workflows

### Workflow 1: Create New Feature Branch

```bash
# 1. Make sure you're on the right base branch
gt branch checkout main

# 2. Pull latest changes
gt sync

# 3. Write your code...

# 4. Stage changes
git add .

# 5. Create branch and commit
gt create -m "feat: add user authentication"

# 6. Submit PR
gt submit --no-interactive
```

### Workflow 2: Add Changes to Existing Branch

```bash
# 1. Make your changes...

# 2. Stage changes
git add .

# 3. Amend the commit (don't create new branch)
gt modify -a

# 4. Update PR
gt submit --no-interactive
```

### Workflow 3: Stack Multiple Changes

```bash
# 1. Start from main
gt branch checkout main
gt sync

# 2. First change
# ... write code ...
git add .
gt create -m "feat: add API endpoint"

# 3. Second change (builds on first)
# ... write code ...
git add .
gt create -m "test: add API tests"

# 4. Third change (builds on second)
# ... write code ...
git add .
gt create -m "docs: document API"

# 5. Submit entire stack
gt submit --stack --no-interactive
```

### Workflow 4: Update Stack After Parent Changes

```bash
# If someone else updated main, or you modified a parent branch:

# 1. Sync with remote
gt sync

# 2. Restack affected branches
gt restack

# 3. Resolve conflicts if any
# (Git will prompt for conflict resolution)

# 4. Continue restack
git rebase --continue

# 5. Update PRs
gt submit --update-only
```

### Workflow 5: Review Teammate's Stack

```bash
# 1. Get their branch
gt get their-branch-name
# Or by PR number: gt get 240665

# 2. View the stack
gt log --stack

# 3. Review changes
git diff main...HEAD

# 4. Switch between branches in stack
gt branch up
gt branch down

# 5. Return to your work
gt branch checkout your-branch
```

### Workflow 6: Insert Branch in Middle of Stack

Useful when you realize you need to split a large PR:

```bash
# 1. Checkout the branch you want to split
gt branch checkout my-large-feature

# 2. Stage only some changes
git add src/api.ts

# 3. Create new branch inserted before current
gt create --insert -m "feat: add API foundation"

# 4. The rest of the changes stay in original branch
# 5. Restack to update dependencies
gt restack
```

## Advanced Features

For power users who need more control over branches and commits:

- **`gt modify`** - Amend or add commits to current branch (vs `gt create` which makes new branch)
- **`gt branch fold`** - Combine branch into parent (useful for merging two PRs)
- **`gt branch edit`** - Interactive rebase for cleaning commit history
- **Git comparison table** - Mapping from git commands to Graphite equivalents
- **Aliases & shortcuts** - Common `gt` aliases (ls, ll, ss, bd, bu, etc.)
- **Advanced patterns** - Splitting branches, reordering stacks, parallel stacks

**See `references/advanced-features.md` for detailed examples and usage.**

## Troubleshooting

### Stack Shows "Needs Restack"

**Problem:** Stack is out of sync with parent branches

**Solution:**
```bash
gt restack
```

If conflicts occur, resolve them and continue:
```bash
# Fix conflicts in files
git add .
git rebase --continue

# Or abort and try again
git rebase --abort
```

### Merge Conflicts During Restack

**Problem:** Conflicts occur when restacking after main branch updates

**Detailed Solution:**

1. **Identify the conflict:**
```bash
# Restack starts
gt restack

# Git pauses at conflict
# CONFLICT (content): Merge conflict in src/path/to/file.ts
```

2. **Check conflict status:**
```bash
git status
# Shows files with conflicts
```

3. **Resolve conflicts manually:**
```bash
# Open conflicted files in editor
# Look for conflict markers:
<<<<<<< HEAD (current change)
your code
=======
their code (incoming change)
>>>>>>> commit-hash

# Edit to keep desired code, remove markers
```

4. **Stage resolved files:**
```bash
git add .
```

5. **Continue rebase:**
```bash
git rebase --continue
```

6. **If multiple conflicts:**
```bash
# Repeat steps 3-5 for each conflict
# Git will pause at each conflicted commit
```

7. **If you want to abort:**
```bash
git rebase --abort
# Returns to state before restack
```

8. **After successful restack:**
```bash
# Update PRs
gt submit --update-only
```

**Common Conflict Scenarios:**

**Scenario 1: Same file edited in main and your branch**
- Resolution: Merge changes from both, keep both modifications

**Scenario 2: File deleted in main but modified in your branch**
- Resolution: Decide if file is still needed. If yes, keep it. If no, remove.

**Scenario 3: Dependency updated in main**
- Resolution: Update your usage to match new dependency API

**Tips:**
- Use a merge tool: `git mergetool` (if configured)
- Check tests after resolving: Run relevant tests to verify resolution
- Ask for help: If unsure, check with teammate who made main change
- Consider alternative: Sometimes it's easier to recreate the branch from updated main

### PR Description Not Updating

**Problem:** `gh pr edit` fails with GraphQL errors

**Solution:** Use GitHub API directly:
```bash
gh api repos/shop/world/pulls/<PR_NUMBER> -X PATCH -f body="$(cat /tmp/description.txt)"
```

### Branch Deleted on Remote But Still Local

**Problem:** PR merged but local branch still exists

**Solution:**
```bash
# Sync will prompt to delete
gt sync

# Or delete manually
gt branch delete branch-name
```

### Stack Got Messy

**Problem:** Too many branches, lost track of stack

**Solution:**
```bash
# View stack
gt log --stack

# Delete unnecessary branches
gt branch delete old-branch

# Restack to fix dependencies
gt restack
```

### Accidentally Created Branch Instead of Modifying

**Problem:** Used `gt create` when you meant `gt modify`

**Solution:**
```bash
# 1. Fold the new branch back into parent
gt branch fold

# 2. Or delete the branch and redo
gt branch delete accidental-branch
gt branch checkout correct-branch
gt modify --all -m "correct message"
```

## Best Practices

### Do's

1. **Run `gt sync` daily** - Stay up to date with main and teammates
2. **Use `--no-interactive`** - Faster workflow for submit
3. **Keep stacks small** - 2-4 branches max per stack
4. **Descriptive commit messages** - They become branch names
5. **Stage changes first** - Always `git add` before `gt create`
6. **Check stack before submit** - Run `gt log` to verify
7. **Restack after parent changes** - Keep dependencies updated
8. **Use meaningful branch names** - Auto-generated from commit messages

### Don'ts

1. **Don't use `git commit`** - Use `gt create` or `gt modify` instead
2. **Don't use `git push`** - Use `gt submit` instead
3. **Don't force push manually** - `gt submit` handles this safely
4. **Don't stack too deep** - More than 5 branches gets unwieldy
5. **Don't forget to restack** - After syncing or modifying parents
6. **Don't mix gt and git commands** - Stick to Graphite workflow
7. **Don't delete branches manually** - Use `gt branch delete`

## Integration & Monorepo

Working with Graphite in the Shopify monorepo and with other tools:

**Integration:**
- **GitHub CLI (`gh`)** - Managing PRs, reviews, and checks
- **VS Code** - GitLens, GitHub PRs extension, terminal integration
- **CI/CD** - Bitrise/CircleCI considerations for stacked PRs
- **Linear/Jira** - Linking commits to issues

**Monorepo (`shop/world`):**
- **Always use `--repo shop/world`** with gh commands
- **Working directory matters** - Run from correct subdirectory
- **Sparse checkout** - Only checked-out files appear in diffs
- **Cross-area changes** - How to handle changes spanning multiple areas

**See `references/integration.md` for detailed integration guides and monorepo best practices.**

## Quick Reference Card

### Essential Commands

```bash
# Daily workflow
gt sync                           # Sync with remote
git add .                         # Stage changes
gt create -m "message"            # Create branch + commit
gt submit --no-interactive        # Submit PR

# Navigation
gt log                           # View stack
gt branch down                   # Go to parent
gt branch up                     # Go to child

# Updates
gt modify --all                  # Amend current branch
gt restack                       # Fix stack
gt submit --update-only          # Update PRs only

# Getting work
gt get branch-name               # Checkout teammate's branch
gt get 240665                    # Checkout by PR number
```

### When Things Go Wrong

```bash
# Stack out of sync
gt restack

# Conflicts during restack
# Fix files, then:
git add .
git rebase --continue

# Start over
git rebase --abort
gt restack

# Branch deleted remotely
gt sync  # Will prompt to delete locally

# Lost in the stack
gt log --stack  # Find where you are
gt branch bottom  # Go to base
```

## Additional Resources

- **Graphite Docs:** https://graphite.dev/docs
- **Command Reference:** https://graphite.dev/docs/command-reference
- **Graphite Web:** https://app.graphite.dev (view stacks visually)

## Notes

- Graphite maintains metadata in `.git/graphite` directory
- Branch naming is deterministic from commit messages
- PRs are tracked by Graphite metadata
- `gt` commands are safe - they confirm before destructive operations
- When in doubt, run `gt log` to see your stack state
