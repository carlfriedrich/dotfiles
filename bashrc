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

# Add timestamps to history
HISTTIMEFORMAT='%F %T '

# History size
HISTSIZE=1000000

# Save each command to the history file right after running it
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Append to the history file, don't overwrite it
shopt -s histappend

# Save all lines of a multiple-line command in the same entry
shopt -s cmdhist
shopt -s lithist

# Check the window size after each command and update LINES and COLUMNS
shopt -s checkwinsize

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
# Completion
#-------------------------------------------------------------------------------
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#-------------------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------------------
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
if [ -d ~/.bash_functions.d ]; then
    for file in ~/.bash_functions.d/*; do
        . ${file}
    done
fi

#-------------------------------------------------------------------------------
# Key bindings
#-------------------------------------------------------------------------------
# fzf
source ~/.local/share/fzf/key-bindings.bash

#-------------------------------------------------------------------------------
# Customization
#-------------------------------------------------------------------------------
# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set default editor
export EDITOR=tilde

# Add cargo packages to PATH
path_prepend ${HOME}/.cargo/bin

# exa colors
# Date in grey and size in white
export EXA_COLORS="da=38;5;246:sn=0;38:sb=0;38"
# Own name and groups in yellow and normal style
export EXA_COLORS="${EXA_COLORS}:uu=0;33:gu=0;33"
# Directories in blue, executables in green, both normal style
export EXA_COLORS="${EXA_COLORS}:di=0;34:ex=0;32"
# Immediate files in yellow, normal style
# This is unfortunately a hard-coded list in exa, so we have a long list here:
# https://github.com/ogham/exa/blob/master/src/info/filetype.rs
IMMEDIATE_STYLE="0;33"
IMMEDIATE_FILES=("README*" "readme*" "*.ninja" Makefile Cargo.toml SConstruct
        CMakeLists.txt build.gradle pom.xml Rakefile package.json Gruntfile.js
        Gruntfile.coffee BUILD BUILD.bazel WORKSPACE build.xml Podfile
        webpack.config.js meson.build composer.json RoboFile.php PKGBUILD
        Justfile Procfile Dockerfile Containerfile Vagrantfile Brewfile
        Gemfile Pipfile build.sbt mix.exs bsconfig.json tsconfig.json)
for immediate_file in "${IMMEDIATE_FILES[@]}"; do
    export EXA_COLORS="${EXA_COLORS}:${immediate_file}=${IMMEDIATE_STYLE}"
done

# Allow local customizations in the ~/.bashrc_local file
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi
