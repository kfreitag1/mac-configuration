# Kieran's config

Dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
ghostty/     # terminal emulator
karabiner/   # keyboard remapping
nix/         # nix-darwin system config (base/work/personal modules)
starship/    # shell prompt
tmux/        # terminal multiplexer
zsh/         # shell
```

## Usage

Install nix https://nixos.org/download/

Install homebrew https://brew.sh/

```bash
sudo nix run --extra-experimental-features "nix-command flakes" nix-darwin/master#darwin-rebuild -- switch --flake ./nix
stow .
```

The `personal/` and `work/` packages overlay machine-specific files (e.g. `settings.local.json`, `auth.json`) onto the shared tree. `stow .` skips them via `.stowrc`; the matching overlay is stowed automatically by the nix activation script in `nix/modules/{personal,work}.nix`.

Subsequent rebuilds with

```bash
rebuild
```
