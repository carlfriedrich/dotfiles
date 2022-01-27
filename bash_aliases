# Use colors in coreutils utilities output
alias ls='ls --color=auto'
alias grep='grep --color'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ls aliases
# -a include files starting with .
# -A include files starting with ., but not . and ..
# -C vertical columns layout (default)
# -F append indicator (one of */=>@|) to entries
# -l detailed listing
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
