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
		while read line; do
			tput dim
			echo " $line" | sed "s/\x1B\[m/\x1B\[2m/g"
			tput sgr0
		done |
		tac | sed "1 a \ " | tac
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

# Override forgit:diff to have different enter command. This cannot be done by
# setting FORGIT_DIFF_FZF_OPTS, because the original arguments to forgit::diff
# are needed for that, but they are not known when setting the variable.
forgit::diff() {
	forgit::inside_work_tree || return 1
	local cmd files opts commits repo
	[[ $# -ne 0 ]] && {
		if git rev-parse "$1" -- &>/dev/null ; then
			if [[ $# -gt 1 ]] && git rev-parse "$2" -- &>/dev/null; then
				commits="$1 $2" && files=("${@:3}")
			else
				commits="$1" && files=("${@:2}")
			fi
		else
			files=("$@")
		fi
	}
	repo="$(git rev-parse --show-toplevel)"
	get_files="cd $repo && echo {} | sed 's/.*] *//' | sed 's/  ->  / /'"
	preview_cmd="$get_files | xargs git diff --color=always $commits -- | $forgit_diff_pager"
	# Show additional context on enter compared to preview
	enter_cmd="$get_files | xargs git diff --color=always -U10000 $commits -- | diff-so-fancy | sed -e '4d'"
	# Show commits in prompt
	opts="
		$FORGIT_FZF_DEFAULT_OPTS
		+m -0 --bind=\"enter:execute($enter_cmd |LESS='-Rc~' less)\"
		--preview=\"$preview_cmd\"
		$FORGIT_DIFF_FZF_OPTS
		--prompt=\"$commits > \"
	"
	eval "git diff --name-status $commits -- ${files[*]} | sed -E 's/^([[:alnum:]]+)[[:space:]]+(.*)$/[\1]\t\2/'" |
		sed 's/\t/  ->  /2' | expand -t 8 |
		FZF_DEFAULT_OPTS="$opts" fzf
}
