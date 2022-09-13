if status is-interactive

    # Hide greeting
    set -U fish_greeting

    # Initialize starship prompt
    starship init fish | source

end
