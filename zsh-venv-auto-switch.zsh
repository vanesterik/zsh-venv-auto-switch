function _zsh_venv_auto_switch() {
    # Find the nearest .venv, from the current directory up to the root
    local dir="$PWD"
    while [[ ! -f "$dir/.venv/bin/activate" && "$dir" != "/" ]]; do
        dir="${dir:h}"
    done

    if [[ -f "$dir/.venv/bin/activate" ]]; then
        # Activate only if this project's venv is not already active
        if [[ "$VIRTUAL_ENV" != "$dir/.venv" ]]; then
            if [[ -n "$VIRTUAL_ENV" ]] && typeset -f deactivate >/dev/null; then
                deactivate
            fi
            source "$dir/.venv/bin/activate"
        fi
    else
        # No venv in this directory or above it: deactivate any currently active venv
        if [[ -n "$VIRTUAL_ENV" ]] && typeset -f deactivate >/dev/null; then
            deactivate
        fi
    fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _zsh_venv_auto_switch
_zsh_venv_auto_switch


