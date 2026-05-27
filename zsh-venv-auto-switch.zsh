function _zsh_venv_auto_switch() {
    if [[ -f ".venv/bin/activate" ]]; then
        # Activate only if this project's venv is not already active
        if [[ "$VIRTUAL_ENV" != "$PWD/.venv" ]]; then
            if [[ -n "$VIRTUAL_ENV" ]] && typeset -f deactivate >/dev/null; then
                deactivate
            fi
            source ".venv/bin/activate"
        fi
    else
        # No venv in this directory: deactivate any currently active venv
        if [[ -n "$VIRTUAL_ENV" ]] && typeset -f deactivate >/dev/null; then
            deactivate
        fi
    fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _zsh_venv_auto_switch
_zsh_venv_auto_switch


