# [title]: Remove any preinstalled gnome package

function remove_gnome_packages(){
    # Get the list of installed GNOME packages
    local packages
    packages=$(pacman -Q | grep -i 'gnome' | awk '{print $1}')

    # If no GNOME packages are installed, exit
    if [[ -z "$packages" ]]; then
        echo "[INFO] No GNOME packages found."
        return 0
    fi

    # Define the pre-selected packages for removal
    local preselected_packages=(
        "gnome-connections"
        "gnome-console"
        "gnome-contacts"
        "gnome-maps"
        "gnome-tour"
        "gnome-user-docs"
        "gnome-weather"
    )

    # Convert the installed package list into fzf format
    # Pre-selected packages will have a `*` before them
    local fzf_input=""
    for pkg in $packages; do
        if [[ " ${preselected_packages[*]} " == *" $pkg "* ]]; then
            fzf_input+="* $pkg\n"
        else
            fzf_input+="  $pkg\n"
        fi
    done

    # Display a multi-select menu with pre-selected items
    echo "[INFO] Select GNOME packages to remove (use TAB to select, ENTER to confirm, ESC to skip):"
    local selected
    selected=$(printf "$fzf_input" | fzf --multi --height=20 --border --prompt="Select packages to remove: " | awk '{print $2}')  # Extract package names

    # Handle ESC press (fzf returns an empty string when ESC is pressed)
    if [[ -z "$selected" ]]; then
        echo "[INFO] No packages selected. Skipping removal."
        return 0
    fi

    # Show confirmation message before proceeding
    echo "[WARNING] The following packages will be removed:"
    echo "$selected"
    read -p "Are you sure? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "[INFO] Package removal canceled."
        return 0
    fi

    # Execute package removal using sudo pacman -R
    echo "[INFO] Removing selected packages..."
    sudo pacman -R $selected

    echo "[SUCCESS] Selected GNOME packages have been removed."
}

remove_gnome_packages