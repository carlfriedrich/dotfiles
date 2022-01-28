#-------------------------------------------------------------------------------
# vscode-updateenv
#-------------------------------------------------------------------------------
# Reconnect to current shell's vscode-server after attaching to a screen session
# in order to make the 'code' command work again
# Source: https://superuser.com/a/1613931/1036029
#-------------------------------------------------------------------------------
VARIABLES="\
    VSCODE_GIT_IPC_HANDLE \
    VSCODE_GIT_ASKPASS_NODE \
    VSCODE_GIT_ASKPASS_MAIN \
    VSCODE_IPC_HOOK_CLI \
    PATH GIT_ASKPASS"

# Save X display-related environment variables for use in `screen` sessions.
savescreenenv() {
    # Write a bash script to update the environment.  The script is named for
    # the host so that `screen` sessions on different hosts can have different
    # environments.
    mkdir -p ~/.screenenv
    envfile=~/.screenenv/$(hostname)

    # Any output within this loop is captured to the $envfile script.
    for var in $VARIABLES
    do
        # For each non-empty environment variable, write commands to:
        #  1. Restore the environment variable
        #  2. Set the environment variable in the current `screen` session.
        if [ ! -z "${!var}" ]; then
            echo "export $var='${!var}'"
            echo "screen -X setenv $var '${!var}'"
        fi
    done > $envfile
}

# Restore environment set by `savescreenenv`.  Run this command manually in
# each screen sub-terminal after disconnecting and re-connecting to `screen`.
vscode-updateenv() {
    envfile=~/.screenenv/$(hostname)
    if [ -f $envfile ]; then
        . $envfile
    fi
}

# Alias `screen` to save select environment variables first.
# Do not alias `screen` from within a screen session else old variables could
# be written to $envfile by accident.
unalias screen 2> /dev/null
if ! ${IN_SCREEN:-false}; then
    alias screen='savescreenenv && IN_SCREEN=true screen'
fi
