if status is-interactive

    # Hide greeting
    set -U fish_greeting

    fish_add_path ~/.local/bin

    # Initialize starship prompt
    starship init fish | source

end
