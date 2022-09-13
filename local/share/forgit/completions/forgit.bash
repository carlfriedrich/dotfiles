# forgit completions for bash
# Source this file after forgit

# We're reusing existing git completion functions, so load those first
# and check if completion function exists afterwards.
_completion_loader git
[[ $(type -t __git_complete) == function ]] || return 1

_git_checkout_file()
{
	__gitcomp_nl "$(__git ls-files --modified)"
}

_git_checkout_branch()
{
	__gitcomp_nl "$(__git branch -a --format '%(refname:short)')"
}

_git_checkout_tag()
{
	__gitcomp_nl "$(__git_tags)"
}

_git_branch_delete()
{
	__gitcomp_nl "$(__git_heads)"
}

_git_stash_show()
{
	__gitcomp_nl "$(__git stash list | sed -n -e 's/:.*//p')"
}

# Completion for forgit functions
__git_complete forgit::add _git_add
__git_complete forgit::reset::head _git_reset
__git_complete forgit::log _git_log
__git_complete forgit::diff _git_diff
__git_complete forgit::checkout::file _git_checkout_file
__git_complete forgit::checkout::branch _git_checkout_branch
__git_complete forgit::checkout::commit _git_checkout
__git_complete forgit::checkout::tag _git_checkout_tag
__git_complete forgit::branch::delete _git_branch_delete
__git_complete forgit::revert::commit _git_revert
__git_complete forgit::clean _git_clean
__git_complete forgit::stash::show _git_stash_show
__git_complete forgit::cherry::pick _git_cherry_pick
__git_complete forgit::rebase _git_rebase
__git_complete forgit::fixup _git_branch

# Completion for forgit shell aliases
if [[ -z "$FORGIT_NO_ALIASES" ]]; then
	__git_complete "${forgit_add}" _git_add
	__git_complete "${forgit_reset_head}" _git_reset
	__git_complete "${forgit_log}" _git_log
	__git_complete "${forgit_diff}" _git_diff
	__git_complete "${forgit_checkout_file}" _git_checkout_file
	__git_complete "${forgit_checkout_branch}" _git_checkout_branch
	__git_complete "${forgit_checkout_commit}" _git_checkout
	__git_complete "${forgit_checkout_tag}" _git_checkout_tag
	__git_complete "${forgit_branch_delete}" _git_branch_delete
	__git_complete "${forgit_revert_commit}" _git_revert
	__git_complete "${forgit_clean}" _git_clean
	__git_complete "${forgit_stash_show}" _git_stash_show
	__git_complete "${forgit_cherry_pick}" _git_cherry_pick
	__git_complete "${forgit_rebase}" _git_rebase
	__git_complete "${forgit_fixup}" _git_branch
fi

# Completion for git-forgit wrapper
# This includes git aliases, e.g. "alias.cb=forgit checkout_branch" will
# correctly complete available branches on "git cb".
_git_forgit()
{
	local subcommand cword cur prev cmds

	subcommand="${COMP_WORDS[1]}"
	if [[ "$subcommand" != "forgit" ]]
	then
		# Forgit is obviously called via a git alias. Get the original
		# aliased subcommand and proceed as if it was the previous word.
		prev=$(git config --get "alias.$subcommand" | cut -d' ' -f 2)
		cword=$((${COMP_CWORD} + 1))
	else
		cword=${COMP_CWORD}
		prev=${COMP_WORDS[COMP_CWORD-1]}
	fi

	cur=${COMP_WORDS[COMP_CWORD]}

	cmds="
		add
		reset_head
		log
		diff
		checkout_file
		checkout_branch
		checkout_commit
		checkout_tag
		branch_delete
		revert_commit
		clean
		stash_show
		cherry_pick
		rebase
		fixup
	"

	case ${cword} in
		2)
			COMPREPLY=($(compgen -W "${cmds}" -- ${cur}))
			;;
		3)
			case ${prev} in
				add) _git_add ;;
				reset_head) _git_reset ;;
				log) _git_log ;;
				diff) _git_diff ;;
				checkout_file) _git_checkout_file ;;
				checkout_branch) _git_checkout_branch ;;
				checkout_commit) _git_checkout ;;
				checkout_tag) _git_checkout_tag ;;
				branch_delete) _git_branch_delete ;;
				revert_commit) _git_revert ;;
				clean) _git_clean ;;
				stash_show) _git_stash_show ;;
				cherry_pick) _git_cherry_pick ;;
				rebase) _git_rebase ;;
				fixup) _git_branch ;;
			esac
			;;
		*)
			COMPREPLY=()
			;;
	esac
}
