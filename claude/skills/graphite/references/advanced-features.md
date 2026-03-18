# Graphite Advanced Features

Advanced Graphite commands and patterns for power users.

## Modifying Branches

### `gt modify` - Amend current branch

```bash
# Amend with staged changes
gt modify

# Stage all and amend
gt modify --all

# Create new commit instead of amending
gt modify --commit

# Edit commit message
gt modify --edit
```

**Key difference from `gt create`:**
- `gt create` - Makes a NEW branch
- `gt modify` - Updates CURRENT branch (amend or new commit)

**When to use:**
- Adding changes to current branch
- Fixing mistakes in current commit
- Updating commit message
- Creating additional commit on current branch

---

## Branch Folding

### `gt branch fold` - Combine branch into parent

```bash
# Fold current branch into its parent
gt branch fold

# What it does:
# - Moves all commits to parent branch
# - Deletes current branch
# - Restacks descendants
# - Keeps PR open (you need to close manually)
```

**Use cases:**
- Two PRs that should be one
- Simplifying a stack
- Cleaning up unnecessary branches

**Example workflow:**
```bash
# You have:
main → feature-base → feature-extra

# You realize feature-extra should be part of feature-base
gt branch checkout feature-extra
gt branch fold

# Result:
main → feature-base (now contains both changes)
```

---

## Interactive Rebase

### `gt branch edit` - Rebase branch commits

```bash
# Edit commits in current branch
gt branch edit

# Opens interactive rebase
# - Reorder commits
# - Squash commits
# - Edit commit messages
# - Split commits
```

**Common use cases:**
- Squashing fixup commits
- Reordering commits for better history
- Splitting large commits
- Cleaning up commit messages

**Example:**
```bash
# You have messy commits in your branch
gt branch edit

# In the rebase editor:
pick abc123 Add feature
squash def456 Fix typo
squash ghi789 Fix another typo
pick jkl012 Add tests

# Results in clean history:
# - Add feature (with typo fixes squashed)
# - Add tests
```

---

## Comparison with Standard Git

Quick reference for Git users transitioning to Graphite:

| Task | Standard Git | Graphite |
|------|-------------|----------|
| Create branch | `git checkout -b name` | `gt create -m "message"` |
| Commit changes | `git commit -m "msg"` | `gt create -m "msg"` (creates branch too) |
| Amend commit | `git commit --amend` | `gt modify` |
| Push | `git push` | `gt submit` |
| Pull | `git pull` | `gt sync` |
| Rebase | `git rebase main` | `gt restack` |
| View branches | `git branch -vv` | `gt log` |
| Checkout | `git checkout name` | `gt branch checkout name` |

**Key philosophical differences:**
1. **Graphite**: Branch = commit (one branch per logical change)
2. **Git**: Branch = pointer (multiple commits per branch)
3. **Graphite**: Stacks of small changes (reviewable)
4. **Git**: Large feature branches (harder to review)

---

## Aliases and Shortcuts

Common aliases configured by Graphite:

```bash
gt ls    # gt log short
gt ll    # gt log long
gt ss    # gt submit --stack
gt bd    # gt branch down
gt bu    # gt branch up
gt bc    # gt branch create
gt bco   # gt branch checkout
```

**Custom aliases:**

You can add your own aliases to `~/.gitconfig`:

```bash
[alias]
  # Quick sync and restack
  gsr = !gt sync && gt restack

  # Submit current stack
  gss = !gt submit --stack --no-interactive

  # Quick navigation
  gbd = !gt branch down
  gbu = !gt branch up
```

**Shell aliases (add to ~/.zshrc or ~/.bashrc):**

```bash
# Quick graphite commands
alias gs='gt sync'
alias gss='gt submit --stack --no-interactive'
alias gl='gt log'
alias gr='gt restack'
```

---

## Advanced Patterns

### Pattern 1: Splitting a Large Branch

When you realize your branch should be multiple smaller PRs:

```bash
# Current: one large branch with multiple concerns
gt branch checkout my-large-feature

# Stage only first concern
git add file1.ts file2.ts
gt create --insert -m "feat: add first feature"

# Stage second concern
git add file3.ts file4.ts
gt create --insert -m "feat: add second feature"

# Remaining changes stay in original branch
gt restack

# Result: Stack of three focused branches
```

### Pattern 2: Reordering Stack

When dependencies change:

```bash
# Current: feature-a → feature-b → feature-c
# Want: feature-b → feature-a → feature-c (b doesn't need a)

gt branch checkout feature-b
gt branch parent main  # Rebase onto main instead of feature-a

gt branch checkout feature-a
gt branch parent feature-b  # Now a depends on b

gt restack
```

### Pattern 3: Parallel Stacks from Same Base

When working on multiple independent features:

```bash
# Create first stack
gt branch checkout main
gt create -m "feat: feature-a-base"
gt create -m "feat: feature-a-tests"

# Go back to main for second stack
gt branch checkout main
gt create -m "feat: feature-b-base"
gt create -m "feat: feature-b-tests"

# Result: Two independent stacks
main
├── feature-a-base → feature-a-tests
└── feature-b-base → feature-b-tests
```

---

## Performance Tips

### Speed up `gt sync`

```bash
# Skip interactive prompts
gt sync --force

# Only sync specific trunk
gt sync --trunk main
```

### Speed up `gt submit`

```bash
# Update only, don't create new PRs
gt submit --update-only

# Don't wait for PR creation
gt submit --no-interactive &
```

### Reduce `gt log` clutter

```bash
# Show only current stack
gt log --stack

# Limit depth
gt log --steps 5
```

---

## Troubleshooting Advanced Issues

### Detached HEAD State

**Problem:** Ended up in detached HEAD after rebase

**Solution:**
```bash
# Find your branch
gt log --show-untracked

# Attach to branch
gt branch checkout <branch-name>
```

### Lost Commits

**Problem:** Commits disappeared after restack

**Solution:**
```bash
# Find lost commits
git reflog

# Recover commit
git cherry-pick <commit-hash>
```

### Corrupted Graphite Metadata

**Problem:** `gt` commands fail with metadata errors

**Solution:**
```bash
# Reset Graphite metadata
rm -rf .git/graphite

# Reinitialize
gt repo init

# Recreate branch tracking
gt branch track <branch-name>
```

---

## Notes

- Advanced features are powerful but require understanding
- Always ensure tests pass before using `gt branch fold`
- Interactive rebase can rewrite history - use carefully on shared branches
- Keep backups before complex operations (git stash or temporary branches)
- When in doubt, use standard git commands to understand what's happening
