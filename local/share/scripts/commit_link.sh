#/bin/env bash

# Function to generate a commit link from a short hash
# Arguments:
#   $1 - The short commit hash
# Outputs:
#   A URL linking to the specific commit in the repository
commit_link() {
    local shorthash="$1"

    # Get the full hash from the short hash
    local fullhash
    fullhash=$(git rev-parse "$shorthash" 2>/dev/null)

    if [[ -z "$fullhash" ]]; then
        echo "Invalid commit hash: $shorthash"
        return 1
    fi

    # Get the remote URL
    local remote_url
    remote_url=$(git config --get remote.origin.url 2>/dev/null)

    if [[ -z "$remote_url" ]]; then
        echo "Could not determine remote URL"
        return 1
    fi

    # Parse the remote URL to extract host and repository
    if [[ "$remote_url" =~ [^:\/\/|@]*([://|@])([^/:]+)[:/](.+)\.git ]]; then
        local host="${BASH_REMATCH[2]}"
        local repo="${BASH_REMATCH[3]}"

        # Output the commit link
        echo "https://$host/$repo/commit/$fullhash"
    else
        echo "Could not determine repository or host"
        return 1
    fi
}

# Read from command line argument if present, or from stdin else
commit_link "${1:-$(cat /dev/stdin)}"
