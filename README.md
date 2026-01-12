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

Subsequent rebuilds with

```bash
rebuild
```
