# [title]: Install custom packages

function install_packages(){
    # Define the list of packages available for installation
    local packages=(
        "visual-studio-code-bin"
        "firefox"
        "brave"
        "chromium"
        "discord"
        "vlc"
        "neovim"
        "htop"
        "thunderbird"
        "obs-studio"
        "gparted"
        "steam"
        "spotify"
        "zoom"
    )

    # Convert the package list into fzf format
    local fzf_input=""
    for pkg in "${packages[@]}"; do
        fzf_input+="  $pkg\n"
    done

    # Display the package selection menu
    echo "[INFO] Select packages to install (use TAB to select, ENTER to confirm, ESC to skip):"
    local selected
    selected=$(printf "$fzf_input" | fzf --multi --height=20 --border --prompt="Select packages to install: " | awk '{print $1}')

    # Handle ESC press (fzf returns an empty string when ESC is pressed)
    if [[ -z "$selected" ]]; then
        echo "[INFO] No packages selected. Skipping installation."
        return 0
    fi

    # Show confirmation before proceeding
    echo "[WARNING] The following packages will be installed:"
    echo "$selected"
    read -p "Are you sure? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "[INFO] Package installation canceled."
        return 0
    fi

    # Install selected packages using yay
    echo "[INFO] Installing selected packages..."
    yay -S --noconfirm $selected

    echo "[SUCCESS] Selected packages have been installed."
}

install_packages