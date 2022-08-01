#-------------------------------------------------------------------------------
# forgit
#-------------------------------------------------------------------------------
# Include and customize forgit:
# https://github.com/carlfriedrich/forgit
#-------------------------------------------------------------------------------
FORGIT_FZF_DEFAULT_OPTS="
	--reverse
	--preview-window='top:50%'
	--bind=shift-down:preview-down
	--bind=shift-up:preview-up
	--bind='q:abort'
	--height=100%
"

# Show complete file in fullscreen diff
FORGIT_FULLSCREEN_CONTEXT=10000

# Do not display graph because it takes too long on large repos
FORGIT_LOG_GRAPH_ENABLE=false

# Customize log format: move decorators behind commit message
FORGIT_LOG_FORMAT="%C(auto)%h %s%d"

# Customize log preview: add dimmed diff stat below commit message
FORGIT_LOG_PREVIEW_COMMAND='f() {
	set -- $(echo -- "$@" | grep -Eo "[a-f0-9]+")
	[ $# -eq 0 ] || (
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
	)
}; f {}'

# Use forgit:diff on log enter
FORGIT_LOG_ENTER_COMMAND='echo {} | grep -Eo "[a-f0-9]+" | head -1 |
	xargs -I % bash -ic "forgit::diff %^1 %"'

FORGIT_LOG_FZF_OPTS="
	--preview-window=top:40%
	--preview='$FORGIT_LOG_PREVIEW_COMMAND'
	--bind='enter:execute($FORGIT_LOG_ENTER_COMMAND)'
"

FORGIT_DIFF_FZF_OPTS="
	--exit-0
	--preview-window='top:80%'
"

FORGIT_ADD_FZF_OPTS="
	--preview-window='top:80%'
"

FORGIT_RESET_HEAD_FZF_OPTS="
	--preview-window='top:80%'
"

FORGIT_CHECKOUT_FILE_FZF_OPTS="
	--preview-window='top:80%'
"

# Override aliases
forgit_log="gl"

# Include forgit plugin
source ~/.local/share/forgit/forgit.plugin.zsh
