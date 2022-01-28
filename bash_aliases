# Use colors in coreutils utilities output
alias ls='ls --color=auto'
alias grep='grep --color'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Interpret ANSI color codes in less
alias less='less -R'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'

# ls aliases
# -a include files starting with .
# -A include files starting with ., but not . and ..
# -C vertical columns layout (default)
# -F append indicator (one of */=>@|) to entries
# -l detailed listing
# -v dotfiles first
# -h human-readable size
alias ll='ls -alFhv'
alias la='ls -Av'
alias l='ls -CF'

# Replace ls and tree commands with exa
# -a include files starting with .
# -g display group ownership
# -l detailed listing
alias exa='exa --group-directories-first'
alias ls='exa'
alias ll='exa -lag --git --icons --time-style=long-iso'
alias la='exa -a'
alias l='exa'
alias tree='exa --tree'

# Use verbose mode on rcm commands
alias mkrc='mkrc -v'
alias rcup='rcup -v'
alias rcdn='rcdn -v'
