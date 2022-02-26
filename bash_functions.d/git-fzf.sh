#-------------------------------------------------------------------------------
# git functions with fzf
#-------------------------------------------------------------------------------
# Provide interactive git log and git diff using fzf. Based on:
# https://gist.github.com/junegunn/f4fca918e937e6bf5bad?permalink_comment_id=2731105#gistcomment-2731105
# https://medium.com/@GroundControl/better-git-diffs-with-fzf-89083739a9cb
#-------------------------------------------------------------------------------
git-fuzzy-diff ()
{
	GIT_FD_PREVIEW_PAGER="less --tabs=4 -Rc"
	GIT_FD_ENTER_PAGER=${GIT_FD_PREVIEW_PAGER}
	if [ -x "$(command -v diff-so-fancy)" ]; then
		GIT_FD_PREVIEW_PAGER="diff-so-fancy | ${GIT_FD_PREVIEW_PAGER}"
		GIT_FD_ENTER_PAGER="diff-so-fancy | sed -e '1,4d' | ${GIT_FD_ENTER_PAGER}"
	fi

	# Don't just diff the selected file alone, get related files first using
	# '--name-status -R' in order to include moves and renames in the diff.
	# See for reference: https://stackoverflow.com/q/71268388/3018229
	GIT_FD_PREVIEW_COMMAND='git diff --color=always '$@' -- \
		$(echo $(git diff --name-status -R '$@' | grep {}) | cut -d" " -f 2-) \
		| '$GIT_FD_PREVIEW_PAGER

	# Show additional context compared to preview
	GIT_FD_ENTER_COMMAND='git diff --color=always '$@' -U10000 -- \
		$(echo $(git diff --name-status -R '$@' | grep {}) | cut -d" " -f 2-) \
		| '$GIT_FD_ENTER_PAGER

	GIT_FD_KEYBINDINGS=(
		"shift-down:preview-down"
		"shift-up:preview-up"
		"pgdn:preview-page-down"
		"pgup:preview-page-up"
		"q:abort"
		"enter:execute:${GIT_FD_ENTER_COMMAND}"
	)
	GIT_FD_KEYBINDINGS=$(IFS=','; echo "${GIT_FD_KEYBINDINGS[*]}")

	git diff --name-only $@ | \
		fzf --ansi --reverse --exit-0 --preview "${GIT_FD_PREVIEW_COMMAND}" \
		--preview-window=top:85% --bind "${GIT_FD_KEYBINDINGS}"
}

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
		xargs -I % bash -ic "git-fuzzy-diff %^1 %") <<- "FZF-EOF"
		{}
		FZF-EOF'

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
