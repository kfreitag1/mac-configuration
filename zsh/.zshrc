export STARSHIP_CONFIG=~/.config/starship/starship.toml

export LAST_CMD_OK="1"
export VIM_MODE="insert"

# hack to extract the exit status into a flag for custom
# modules in starship
__set_exit_flag() {
    local last_status=$?

    if [ -z "$__EXIT_FLAG_INITIALIZED" ]; then
        __EXIT_FLAG_INITIALIZED="1"
        return
    fi

    if [ $last_status -eq 0 ]; then
        export LAST_CMD_OK="1"
    else
        export LAST_CMD_OK=""
    fi
}
precmd_functions=(__set_exit_flag)

function zle-keymap-select {
    case $KEYMAP in
        vicmd)      export VIM_MODE="normal" ;;
        main|viins) export VIM_MODE="insert" ;;
    esac
}
zle -N zle-keymap-select
# Reset to insert on each new line
function zle-line-init {
    export VIM_MODE="insert"
}
zle -N zle-line-init


eval "$(starship init zsh)"

alias rebuild='sudo darwin-rebuild switch --flake ~/.config/nix'

export XDG_CONFIG_HOME="/Users/kieran/.config"
export EDITOR="zed --wait"

# zsh vim mode
bindkey -v

# git autocomplete
autoload -Uz compinit && compinit

# aliases
alias cld='claude --dangerously-skip-permissions'
alias clds='claude --dangerously-skip-permissions --model sonnet'

[[ -f "$ZDOTDIR/.zshrc.$MACHINE_PROFILE" ]] && source "$ZDOTDIR/.zshrc.$MACHINE_PROFILE"
