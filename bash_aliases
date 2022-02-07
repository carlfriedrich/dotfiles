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
# -F display type indicator (e.g. "/" on directories)
alias exa='exa --group-directories-first'
alias ls='exa -F'
alias ll='exa -lagF --git --icons --time-style=long-iso'
alias la='exa -aF'
alias l='exa -F'
alias tree='exa --tree'

# Use verbose mode on rcm commands
alias mkrc='mkrc -v'
alias rcup='rcup -v'
alias rcdn='rcdn -v'

# History reload (to have history of other running shells)
alias hr='history -c; history -r'

# Reload .bashrc
alias sbrc='source ~/.bashrc'
