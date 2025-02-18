#-------------------------------------------------------------------------------
# forgit
#-------------------------------------------------------------------------------
# Include and customize forgit:
# https://github.com/wfxr/forgit
#-------------------------------------------------------------------------------
export FORGIT_FZF_DEFAULT_OPTS="
	--reverse
	--exact
	--preview-window='top:50%'
	--bind=shift-down:preview-down+preview-down+preview-down+preview-down
	--bind=shift-up:preview-up+preview-up+preview-up+preview-up
	--bind='q:abort'
	--height=100%
	--info=inline-right
	--track
"

# Custom preview: show commit message with dimmed diff stat below
export FORGIT_CUSTOM_PREVIEW='
	git show --no-patch --color=always $1
	echo
	git show --stat --format="" --color=always $1 |
	sed "\$i\ " |
	while read line; do
		tput dim
		# replace color code for red with dimmed red, otherwise files with
		# additions and deletions (showing a "+++---" kind of stats) still
		# print the "-" chars in normal red
		echo " $line" | sed "s/\x1B\[m/\x1B\[2m/g"
		tput sgr0
	done
'

# Show complete file in fullscreen diff
export FORGIT_FULLSCREEN_CONTEXT=10000

# Scroll file contents to top on fullscreen diff
export FORGIT_ENTER_PAGER="LESS='-Rc' less"

# Do not display graph because it takes too long on large repos
export FORGIT_LOG_GRAPH_ENABLE=false

# Customize log format: move decorators behind commit message
export FORGIT_LOG_FORMAT="%C(auto)%h %s%d"

# Use custom preview in log
export FORGIT_LOG_PREVIEW_COMMAND='f() {
	set -- $(echo -- "$@" | grep -Eo "[a-f0-9]+")
	[ $# -eq 0 ] || ('$FORGIT_CUSTOM_PREVIEW')
}; f {}'

# Checkout on alt-enter
export FORGIT_LOG_CHECKOUT_COMMAND='echo {} | cut -d" " -f1 | xargs -I % git checkout %'

# Revert on alt-backspace
export FORGIT_LOG_REVERT_COMMAND='echo {} | cut -d" " -f1 | xargs -I % git revert %'

# Rebase on ctrl-r
export FORGIT_LOG_REBASE_COMMAND='echo {} | cut -d" " -f1 | xargs -I % git rebase -i %'

# Open in browser on ctrl-b
export FORGIT_LOG_BROWSER_COMMAND='echo {} | cut -d" " -f1 | ~/.local/share/scripts/commit_link.sh | xargs -I % www-browser %'

export FORGIT_LOG_FZF_OPTS="
	--preview-window=top:40%
	--preview='$FORGIT_LOG_PREVIEW_COMMAND'
	--bind='alt-enter:execute($FORGIT_LOG_CHECKOUT_COMMAND)+cancel'
	--bind='alt-bspace:execute($FORGIT_LOG_REVERT_COMMAND)+cancel'
	--bind='ctrl-r:execute($FORGIT_LOG_REBASE_COMMAND)+cancel'
	--bind='ctrl-b:execute($FORGIT_LOG_BROWSER_COMMAND)'
	--bind='ctrl-s:accept'
	--border=bottom
	--border-label=' [ENTER] show - [ALT+ENTER] checkout - [ALT+BACKSPACE] revert - [CTRL+R] rebase - [CTRL+B] open browser '
	--color=label:gray
"

# Use custom preview in stash
export FORGIT_STASH_PREVIEW_COMMAND='f() {
	set -- $(echo -- "$@" | grep -Eo "stash@\{[0-9]*\}")
	[ $# -eq 0 ] || ('$FORGIT_CUSTOM_PREVIEW')
}; f {}'

# Use forgit diff on stash enter
export FORGIT_STASH_ENTER_COMMAND='echo {} | cut -d: -f1 | xargs -I % git forgit diff %^1 %'

# Pop stash on alt-enter
export FORGIT_STASH_POP_COMMAND='echo {} | cut -d: -f1 | xargs -I % git stash pop %'

# Drop stash on alt-backspace
export FORGIT_STASH_DROP_COMMAND='echo {} | cut -d: -f1 | xargs -I % git stash drop %'

export FORGIT_STASH_FZF_OPTS="
	--preview-window=top:50%
	--preview='$FORGIT_STASH_PREVIEW_COMMAND'
	--bind='enter:execute($FORGIT_STASH_ENTER_COMMAND)'
	--bind='alt-enter:execute($FORGIT_STASH_POP_COMMAND)+accept'
	--bind='alt-bspace:execute($FORGIT_STASH_DROP_COMMAND)+reload(git stash list)'
	--border=bottom
	--border-label=' [ENTER] show - [ALT+ENTER] pop - [ALT+BACKSPACE] drop '
	--color=label:gray
"

export FORGIT_DIFF_FZF_OPTS="
	--exit-0
	--preview-window='top:80%'
	--border=none
"

export FORGIT_ADD_FZF_OPTS="
	--preview-window='top:80%'
"

export FORGIT_RESET_HEAD_FZF_OPTS="
	--preview-window='top:80%'
"

export FORGIT_CHECKOUT_FILE_FZF_OPTS="
	--preview-window='top:80%'
"

# Use Windows clipboard in WSL
if which clip.exe > /dev/null; then
	export FORGIT_COPY_CMD="clip.exe"
fi

# Bind forgit log to Ctrl+G and insert selected sha into prompt
__forgit_log() {
	git forgit log | cut -d' ' -f1
}
__call_and_insert_stdout_to_prompt() {
	local stdout after_cursor_count before_cursor after_cursor
	stdout=$($1)
	after_cursor_count=$(( ${#READLINE_LINE} - ${READLINE_POINT} ))
	before_cursor=${READLINE_LINE:0:${READLINE_POINT}}
	after_cursor=${READLINE_LINE:${READLINE_POINT}:${after_cursor_count}}
	READLINE_LINE="${before_cursor}${stdout}${after_cursor}"
	READLINE_POINT=$(( ${READLINE_POINT} + ${#stdout} ))
}
bind -x '"\C-g":__call_and_insert_stdout_to_prompt __forgit_log'
