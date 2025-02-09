# [title]: shortcuts
function import_gnome_shortcuts() {
    local SHORTCUTS_DIR="$(dirname "$(realpath "$0")")"
    local IMPORT_SCRIPT="$SHORTCUTS_DIR/import.sh"

    # Ask the user for confirmation
    read -p "Do you want to import GNOME shortcuts from $SHORTCUTS_DIR? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "[INFO] Shortcut import skipped."
        return 0
    fi

    # Check if the import script exists
    if [[ ! -f "$IMPORT_SCRIPT" ]]; then
        echo "[ERROR] Import script not found: $IMPORT_SCRIPT"
        return 1
    else
        # Execute the import script
        echo "[INFO] Importing GNOME shortcuts..."
        chmod +x "$IMPORT_SCRIPT"
        cd $SHORTCUTS_DIR
        "$IMPORT_SCRIPT"
        echo "[SUCCESS] GNOME shortcuts have been imported."
    fi

}

import_gnome_shortcuts