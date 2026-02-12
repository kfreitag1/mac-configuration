eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

alias rebuild='sudo darwin-rebuild switch --flake ~/.config/nix'

export XDG_CONFIG_HOME="/Users/kieran/.config"
export EDITOR="zed --wait"

# git autocomplete
autoload -Uz compinit && compinit

# aliases
alias clauded='claude --dangerously-skip-permissions'

[[ -f "$ZDOTDIR/.zshrc.$MACHINE_PROFILE" ]] && source "$ZDOTDIR/.zshrc.$MACHINE_PROFILE"
