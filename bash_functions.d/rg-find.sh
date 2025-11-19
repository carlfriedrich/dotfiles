# See https://github.com/junegunn/fzf/blob/master/ADVANCED.md#ripgrep-integration

# 1. Search for text in files using Ripgrep
# 2. Interactively restart Ripgrep with reload action
# 3. Open the file in editor
# 4. Use Alt+Enter to open file without closing fzf
# 5. Use Tab to toggle preview

__rg_find() {
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    FZF_RELOAD_COMMAND="reload:sleep 0.1; $RG_PREFIX {q} || true"
    FZF_RELOAD_COMMAND_HIDDEN="reload:sleep 0.1; $RG_PREFIX --hidden {q} || true"
    INITIAL_QUERY="${*:-}"
    IFS=: read -ra selected < <(
      FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
      fzf --ansi \
          --disabled --query "$INITIAL_QUERY" \
          --bind 'change:transform:[[ $FZF_PROMPT =~ \+hidden ]] && \
              echo "'"$FZF_RELOAD_COMMAND_HIDDEN"'" || \
              echo "'"$FZF_RELOAD_COMMAND"'"' \
          --bind "alt-enter:execute-silent($EDITOR -g '{1}:{2}:{3}')" \
          --bind "tab:toggle-preview" \
          --bind 'ctrl-h:transform:[[ ! $FZF_PROMPT =~ \+hidden ]] && \
              echo "change-prompt(+hidden> )+reload('"$FZF_RELOAD_COMMAND_HIDDEN"')" || \
              echo "change-prompt(> )+reload('"$FZF_RELOAD_COMMAND"')"' \
          --delimiter : \
          --preview 'bat --color=always {1} --style=numbers --highlight-line {2}' \
          --preview-window 'up,50%,+{2}/2:hidden' \
          --border bottom \
          --border-label " [TAB] preview - [ALT+ENTER] open in editor - [CTRL+H] toggle hidden files " \
          --color=label:gray
    )
    [ -n "${selected[0]}" ] && $EDITOR -g "${selected[0]}:${selected[1]}"
}

# Bind to Ctrl+F
bind -x '"\C-f": __rg_find'
