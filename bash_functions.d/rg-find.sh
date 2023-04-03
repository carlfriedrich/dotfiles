# See https://github.com/junegunn/fzf/blob/master/ADVANCED.md#ripgrep-integration

# 1. Search for text in files using Ripgrep
# 2. Interactively restart Ripgrep with reload action
# 3. Open the file in editor
# 4. Use Alt+Enter to open file without closing fzf
# 5. Use Tab to toggle preview

__rg_find() {
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    IFS=: read -ra selected < <(
      FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
      fzf --ansi \
          --disabled --query "$INITIAL_QUERY" \
          --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
          --bind "alt-enter:execute-silent(code -g '{1}:{2}:{3}')" \
          --bind "tab:toggle-preview" \
          --delimiter : \
          --preview 'bat --color=always {1} --style=numbers --highlight-line {2}' \
          --preview-window 'up,50%,+{2}/2:hidden' \
    )
    [ -n "${selected[0]}" ] && code -g "${selected[0]}:${selected[1]}"
}

# Bind to Ctrl+F
bind -x '"\C-f": __rg_find'
