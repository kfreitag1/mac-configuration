# Graphite Integration & Monorepo Guide

Guide for using Graphite with other tools and in the Shopify monorepo context.

## Integration with Other Tools

### With GitHub CLI (`gh`)

Graphite works seamlessly with GitHub CLI for enhanced PR management:

```bash
# Get PR details
gh pr view <number> --repo shop/world

# View PR in browser (from Graphite branch)
gt pr

# Check PR status
gh pr status

# View PR checks
gh pr checks <number> --repo shop/world

# Review PR
gh pr review <number> --approve
gh pr review <number> --request-changes --body "Please fix X"

# Merge PR
gh pr merge <number> --squash
gh pr merge <number> --merge
gh pr merge <number> --rebase

# Comment on PR
gh pr comment <number> --body "LGTM!"

# View PR diff
gh pr diff <number>

# Get PR JSON data
gh pr view <number> --json number,title,state,reviewDecision
```

**Workflow integration:**
```bash
# Submit with Graphite
gt submit --no-interactive

# Then use gh for reviews
gh pr list --author @me
gh pr view 12345
```

---

### With VS Code

**Extensions that work well with Graphite:**

1. **GitLens** - Shows stacked branches in graph view
   - View commit history per branch
   - See parent/child relationships
   - Visualize stack structure

2. **GitHub Pull Requests** - Manage PRs from VS Code
   - View PR status
   - Review code
   - Comment on PRs
   - All Graphite PRs appear here

3. **Git Graph** - Alternative visualization
   - Shows branch relationships
   - Stacked commits visible
   - Interactive rebase support

**Terminal integration:**
- Use integrated terminal for `gt` commands
- Commands work same as external terminal
- See changes reflected in Source Control panel

**Keyboard shortcuts:**
Add to VS Code settings.json:
```json
{
  "terminal.integrated.commandsToSkipShell": [
    "graphite.sync",
    "graphite.submit"
  ]
}
```

---

### With Linear/Jira

Link commits to issues:

```bash
# In commit message, reference issue
gt create -m "feat: add feature [LIN-123]"
gt create -m "fix: resolve bug JIRA-456"

# Graphite maintains these references through rebases
```

---

### With Slack

Get notified about PR updates:

1. **GitHub Slack App** - Notifies on PR events
   - Works with all Graphite PRs
   - Subscribe to specific repos
   - Get review requests

2. **Graphite Slack App** - Stack-specific notifications
   - Notifies when stack needs attention
   - Stack merge updates
   - Review status changes

---

### With CI/CD (Bitrise/CircleCI)

Graphite PRs trigger CI normally:

**Best practices:**
```bash
# Ensure tests pass before submitting
pnpm test
gt submit

# Check CI status
gh pr checks <number> --repo shop/world

# Rerun failed CI
gh pr checks <number> --repo shop/world
gh run rerun <run-id>
```

**CI considerations for stacks:**
- Each PR in stack runs CI independently
- CI must pass for each PR before merging
- Bottom PR merges first, then restack and merge next

---

## Monorepo Considerations

This repository (`shop/world`) is a large monorepo with special considerations.

### Always Specify Repo

GitHub CLI commands require explicit repo specification:

```bash
# Correct - specify repo
gh pr view 240665 --repo shop/world
gh api repos/shop/world/pulls/240665
gh pr list --repo shop/world

# Wrong - may use wrong repo or fail
gh pr view 240665
gh pr list
```

**Add to shell profile (~/.zshrc or ~/.bashrc):**
```bash
# Set default repo for gh commands
export GH_REPO="shop/world"

# Now gh commands work without --repo flag
gh pr view 240665  # Uses shop/world automatically
```

---

### Working Directory Matters

Graphite tracks branches per working directory:

```bash
# Graphite metadata is per directory
# Make sure you're in the right place

# Check current location
pwd
# Should be: ~/world/trees/root/src/areas/clients/admin-mobile

# If wrong directory, Graphite won't see your branches
cd ~/world/trees/root/src/areas/clients/admin-mobile

# Then Graphite commands work
gt log
```

**Why this matters:**
- `~/world` has multiple areas (clients, services, etc.)
- Each area can have independent Graphite stacks
- Being in wrong directory shows wrong branches

**Tip:** Add to shell profile:
```bash
# Alias to quickly jump to admin-mobile
alias cdmobile='cd ~/world/trees/root/src/areas/clients/admin-mobile'
```

---

### Multiple Trunks

Different areas may use different trunk branches:

**In admin-mobile:**
- Trunk: `main`
- Check with: `gt log` (shows trunk at bottom)

**Other areas might use:**
- `master`
- `develop`
- `production`

**How to check:**
```bash
# See what trunk Graphite uses
gt log  # Bottom branch is trunk

# Change trunk if needed
gt repo init --trunk main
```

---

### Sparse Checkout Considerations

The monorepo uses sparse checkout (not all files checked out):

**Impacts on Graphite:**
- `gt sync` only syncs checked-out areas
- Diffs only show checked-out files
- Branch operations work normally

**If you need files from other areas:**
```bash
# Check what's included in sparse checkout
git sparse-checkout list

# Add more paths if needed
git sparse-checkout add areas/services/some-service
```

---

### Monorepo-Specific Workflows

#### Workflow: Cross-Area Changes

When changes span multiple areas:

```bash
# Option 1: Separate stacks per area (preferred)
cd ~/world/trees/root/src/areas/clients/admin-mobile
gt create -m "feat: mobile changes"

cd ~/world/trees/root/src/areas/services/api
gt create -m "feat: API changes"

# Option 2: Single stack with cross-area changes
cd ~/world/trees/root/src
gt create -m "feat: cross-area feature"
# But keep PRs focused on specific areas
```

#### Workflow: Shared Dependencies

When updating shared packages:

```bash
# Update shared package first
cd ~/world/trees/root/src/packages/shared-utils
gt create -m "feat: add utility function"
gt submit

# Then update consumers
cd ~/world/trees/root/src/areas/clients/admin-mobile
gt create -m "feat: use new utility"
gt submit

# Stack depends on first PR merging
```

---

### Monorepo Performance

**Large repo considerations:**

1. **`gt sync` can be slow**
   ```bash
   # Sync only current trunk (faster)
   gt sync --trunk main

   # Skip fetching all refs
   git fetch origin main
   gt restack
   ```

2. **`gt log` shows many branches**
   ```bash
   # Show only your stack
   gt log --stack

   # Limit branches shown
   gt log --steps 10
   ```

3. **Large diffs**
   ```bash
   # Diff only specific paths
   git diff main...HEAD -- src/areas/clients/admin-mobile/

   # Exclude generated files
   git diff main...HEAD -- ':!**/generated/*'
   ```

---

### Monorepo Best Practices

**Do's:**
- Keep changes focused on single area when possible
- Use `--repo shop/world` with gh commands
- Verify working directory before Graphite commands
- Use `gt log --stack` to reduce noise
- Coordinate cross-area changes with other teams

**Don'ts:**
- Don't mix unrelated area changes in one PR
- Don't assume gh commands use shop/world automatically
- Don't run Graphite commands from wrong directory
- Don't create huge stacks that span multiple areas
- Don't forget to sync before creating new branches

---

### Troubleshooting Monorepo Issues

#### Issue: `gt` commands fail with "not in a git repository"

**Cause:** Wrong working directory

**Solution:**
```bash
cd ~/world/trees/root/src/areas/clients/admin-mobile
gt log  # Should work now
```

#### Issue: `gh pr view` fails with "could not resolve to a Repository"

**Cause:** Missing `--repo` flag

**Solution:**
```bash
# Add --repo flag
gh pr view 12345 --repo shop/world

# Or set default
export GH_REPO="shop/world"
```

#### Issue: `gt log` shows branches from other areas

**Cause:** Graphite tracking branches from parent directory

**Solution:**
```bash
# Ensure you're in correct subdirectory
cd ~/world/trees/root/src/areas/clients/admin-mobile

# If issue persists, reinit Graphite
gt repo init
```

#### Issue: Changes to other areas appearing in diff

**Cause:** Sparse checkout not configured correctly

**Solution:**
```bash
# Check sparse checkout
git sparse-checkout list

# Reconfigure to only include admin-mobile
git sparse-checkout set areas/clients/admin-mobile
```

---

## Related Documentation

- [World Monorepo Structure](../../docs/architecture/project_structure.md)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Graphite Documentation](https://graphite.dev/docs)
- [VS Code GitLens](https://gitlens.amod.io/)
