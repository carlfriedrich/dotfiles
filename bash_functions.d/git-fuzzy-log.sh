#-------------------------------------------------------------------------------
# git-fuzzy-log
#-------------------------------------------------------------------------------
# Provide an interactive git log using fzf. Based on:
# https://gist.github.com/junegunn/f4fca918e937e6bf5bad?permalink_comment_id=2731105#gistcomment-2731105
#-------------------------------------------------------------------------------
GIT_FL_ENTER_COMMAND="(grep -o '[a-f0-9]\{7\}' | head -1 |
	xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
	{}
FZF-EOF"
GIT_FL_PREVIEW_COMMAND='f() { \
	set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); \
	[ $# -eq 0 ] || git show --no-patch --color=always $1 ; \
}; f {}'
GIT_FL_KEYBINDINGS="\
shift-down:preview-down,\
shift-up:preview-up,\
pgdn:preview-page-down,\
pgup:preview-page-up,\
q:abort,\
enter:execute:${GIT_FL_ENTER_COMMAND}\
"
git-fuzzy-log ()
{
	git log --graph --color=always --format="%C(auto)%h %s%d " | \
		fzf --ansi --no-sort --reverse --tiebreak=index \
		--preview "${GIT_FL_PREVIEW_COMMAND}" --preview-window=top:15 \
		--bind "${GIT_FL_KEYBINDINGS}"
}
