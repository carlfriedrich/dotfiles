#-------------------------------------------------------------------------------
# man
#-------------------------------------------------------------------------------
# Add colors to man pages. Source:
# https://www.howtogeek.com/683134/how-to-display-man-pages-in-color-on-linux/
#-------------------------------------------------------------------------------
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    command man "$@"
}
