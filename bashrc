#-------------------------------------------------------------------------------
# .bashrc
#-------------------------------------------------------------------------------
# If not running interactively, don't do anything
# This is crucial for correct functioning of scp, as explained here:
# https://unix.stackexchange.com/q/257571/317320
case $- in
    *i*) ;;
      *) return;;
esac

#-------------------------------------------------------------------------------
# Bash options
#-------------------------------------------------------------------------------
# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# History size
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and update LINES and COLUMNS
shopt -s checkwinsize

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------
BOLD='\[\e[1m\]'
RESET='\[\e[0m\]'
DEFAULT='\[\e[39m\]'
RED='\[\e[31m\]'
GREEN='\[\e[32m\]'
YELLOW='\[\e[33m\]'
BLUE='\[\e[34m\]'
MAGENTA='\[\e[35m\]'
CYAN='\[\e[36m\]'
# \d  date
# \h  hostname
# \t  time
# \u  user
# \w  working directory
# \!  history number of this command
# \#  command number of this command
# \$  $ for non-root, # for root
PS1="${GREEN}\u@\h${RESET}:${BLUE}\w${RESET}\$ "

#-------------------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------------------
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#-------------------------------------------------------------------------------
# Customization
#-------------------------------------------------------------------------------
# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set default editor
export EDITOR=tilde

# Allow local customizations in the ~/.bashrc_local file
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi
