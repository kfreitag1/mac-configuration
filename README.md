# config

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

```bash
stow .          # symlink all packages to ~/.config
stow <package>  # symlink a single package
```
