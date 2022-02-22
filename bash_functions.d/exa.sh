#-------------------------------------------------------------------------------
# exa
#-------------------------------------------------------------------------------
# Modify exa output
#-------------------------------------------------------------------------------
function exa()
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

    function reorder_columns()
    {
        # Move size between group and date
        # Solution from here:
        # https://github.com/ogham/exa/issues/161#issuecomment-1035644531
        # And using custom 'column' implementation due to color codes:
        # https://stackoverflow.com/a/70513399/3018229
        # https://github.com/LukeSavefrogs/column_ansi
        sed -E 's/^ *([^ ]*) *([^ ]*) *([^ ]*) *([^ ]*) *([^ ]* *[^ ]*) *(.*)$/\1\t\3\t\4\t\2\t\5\t\6/' | \
        column_ansi -t -s $'\t' -o ' ' -R 4
    }

    command exa ${COLOR_ARG} $@ | replace_git_icon | reorder_columns
}
