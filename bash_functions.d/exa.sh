#-------------------------------------------------------------------------------
# exa
#-------------------------------------------------------------------------------
# Modify exa output
#-------------------------------------------------------------------------------
function _exa()
{
    # check if output is redirected
    # https://stackoverflow.com/q/26761627/3018229
    if [ -t 1 ]; then
        COLOR_ARG="--color=always"
    else
        COLOR_ARG=""
    fi

    function replace_git_icon()
    {
        sed 's/ / /g'
    }

    function remove_trailing_spaces()
    {
        sed 's/ *$//'
    }

    function reorder_columns()
    {
        # Move size between group and date
        # Solution from here:
        # https://github.com/ogham/exa/issues/161#issuecomment-1035644531
        # And using custom 'column' implementation due to color codes:
        # https://stackoverflow.com/a/70513399/3018229
        # https://github.com/LukeSavefrogs/column_ansi

        # General column
        C="([^ ]*)"

        # Date column has two words
        CDATE="([^ ]* *[^ ]*)"

        # Git column needs special treatment because it is optional and has
        # varying colours within the token
        CGIT="([^ ]*[-NMDIU][^ ]*[-NMDIU][^ ]*)?"

        # Output order with tabs in between
        OUT="\1\t\3\t\4\t\2\t\5\t\6\t\7"

        # Parse columns and reorder them
        sed -E "s/^$C +$C +$C +$C +$CDATE +$CGIT *(.*)$/$OUT/" | \
        # Remove double tabs (occur when git column is not present)
        sed -E 's/\t\t/\t/g' | \
        # Display as beautiful table with two spaces and right-aligned size
        column_ansi -t -s $'\t' -o '  ' -R 4
    }

    exa ${COLOR_ARG} $@ | replace_git_icon | reorder_columns | \
        remove_trailing_spaces
}
