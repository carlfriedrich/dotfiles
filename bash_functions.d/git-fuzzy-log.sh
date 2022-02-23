#-------------------------------------------------------------------------------
# git-fuzzy-log
#-------------------------------------------------------------------------------
# Provide an interactive git log using fzf. Based on:
# https://gist.github.com/junegunn/f4fca918e937e6bf5bad?permalink_comment_id=2731105#gistcomment-2731105
#-------------------------------------------------------------------------------
git-fuzzy-log ()
{
	GIT_FL_PREVIEW_COMMAND='f() {
		set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}")
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

	GIT_FL_ENTER_COMMAND='(grep -o "[a-f0-9]\{7\}" | head -1 |
		xargs -I % sh -c "git show --color=always % | diff-so-fancy | 
		less --tabs=4 -R") <<- "FZF-EOF"
		{}
		FZF-EOF'

	# Define keybindings in array and then convert it to a comma-separated list
	GIT_FL_KEYBINDINGS=(
		"shift-down:preview-down"
		"shift-up:preview-up"
		"pgdn:preview-page-down"
		"pgup:preview-page-up"
		"q:abort"
		"enter:execute:${GIT_FL_ENTER_COMMAND}"
	)
	GIT_FL_KEYBINDINGS=$(IFS=','; echo "${GIT_FL_KEYBINDINGS[*]}")

	git log --graph --color=always --format="%C(auto)%h %s%d " | \
		fzf --ansi --no-sort --reverse --tiebreak=index \
		--preview "${GIT_FL_PREVIEW_COMMAND}" --preview-window=top:15 \
		--bind "${GIT_FL_KEYBINDINGS}"
}
