export PATH="$PATH:/Users/kieran/.lmstudio/bin"

# Nix!
export NIX_CONF_DIR=$HOME/.config/nix
export PATH=/run/current-system/sw/bin:$PATH

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

export PATH="/opt/homebrew/bin:$PATH"

alias rebuild='sudo darwin-rebuild switch --flake ~/.config/nix'

export XDG_CONFIG_HOME="/Users/kieran/.config"
export EDITOR="zed --wait"
