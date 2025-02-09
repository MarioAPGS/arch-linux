# Ensure fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf is required but not installed. Please install fzf first:"
    sudo pacman -S fzf
fi

exec_init() {
    local SCRIPT_PATH=$1
    local -a OPTIONS=("${!2}")  # Convert to option list
    local QUESTION="$3"
    local DEBUG=${4:-true}      # true by default

    # If there is only one option, ask directly instead of showing a menu
    if [[ "${#OPTIONS[@]}" -eq 1 ]]; then
        read -p "${QUESTION}? (y/N): " confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            echo "[INFO] Installation skipped."
            return 0
        fi
        choice="${OPTIONS[0]}"
    else
        # Ask the question
        echo "$QUESTION"

        # Use fzf for interactive selection
        local choice=$(printf "%s\n" "${OPTIONS[@]}" | fzf --height=10 --border --prompt="Select an option: ")

        # If no selection was made, exit
        if [[ -z "$choice" ]]; then
            echo "No option selected. Exiting..."
            exit 1
        fi
    fi

    echo "Selected: $choice"

    # Define the path to the init.sh script
    script="${SCRIPT_PATH}/${choice}/init.sh"
    
    # Check if the script file exists
    if [[ ! -f "$script" ]]; then
        echo "[ERROR] Script not found: $script"
        return 1
    fi

    # Debug messages
    if [[ "$DEBUG" == "true" ]]; then
        echo "[INFO] Preparing to execute script: $script"
    fi

    # Ensure the script is executable
    if [[ ! -x "$script" ]]; then
        if [[ "$DEBUG" == "true" ]]; then
            echo "[INFO] Making script executable: $script"
        fi
        chmod +x "$script"
    fi

    if [[ "$DEBUG" == "true" ]]; then
        echo "[INFO] Running script: $script"
        echo "-----------------------------------"
    fi
    
    # Execute the script, ceding control to it
    "$script"
}

exec_scripts() {
    local SCRIPT_PATH="$1"
    local -a FILES=("${!2}")  # Convert to list of script names (without .sh)
    local QUESTION="$3"
    local DEBUG=${4:-true}  # true by default

    # Create an associative array to map script names to their display titles
    declare -A SCRIPT_TITLES
    local fzf_input=""

    for script in "${FILES[@]}"; do
        local script_file="${SCRIPT_PATH}${script}"

        # If the user didn't include ".sh", add it (but allow subdirectories)
        [[ ! "$script" =~ \.sh$ ]] && script_file+=".sh"

        if [[ -f "$script_file" ]]; then
            # Try to extract the title from the script
            local title=$(grep -m 1 -oP '(?<=# \[title\]: ).*' "$script_file")

            # If a title is found, use it; otherwise, use the filename
            SCRIPT_TITLES["$script"]="${title:-$script}"
            fzf_input+="${SCRIPT_TITLES[$script]}\n"
        fi
    done

    local selected_scripts=()

    # If only one script is available, ask directly instead of showing a menu
    if [[ "${#FILES[@]}" -eq 1 ]]; then
        read -p "Run ${SCRIPT_TITLES[${FILES[0]}]}? (y/N): " confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            echo "[INFO] Execution skipped."
            return 0
        fi
        selected_scripts=("${FILES[0]}")
    else
        # Ask the question
        echo "$QUESTION"

        # Use fzf for multi-selection
        local selected_titles=$(printf "$fzf_input" | fzf --multi --height=10 --border --prompt="Select scripts to execute: ")

        # If no selection was made, exit
        if [[ -z "$selected_titles" ]]; then
            echo "[INFO] No scripts selected. Exiting..."
            return 0
        fi

        # Map selected titles back to script names
        for key in "${!SCRIPT_TITLES[@]}"; do
            if echo "$selected_titles" | grep -Fxq "${SCRIPT_TITLES[$key]}"; then
                selected_scripts+=("$key")
            fi
        done
    fi

    echo "Selected scripts: ${selected_scripts[*]}"

    # Execute each selected script
    for script_name in "${selected_scripts[@]}"; do
        local script="${SCRIPT_PATH}${script_name}"

        # If the user didn't include ".sh", add it (but allow subdirectories)
        [[ ! "$script_name" =~ \.sh$ ]] && script+=".sh"

        # Check if the script file exists
        if [[ ! -f "$script" ]]; then
            echo "[ERROR] Script not found: $script"
            continue
        fi

        # Debug messages
        if [[ "$DEBUG" == "true" ]]; then
            echo "[INFO] Preparing to execute script: $script"
        fi

        # Ensure the script is executable
        if [[ ! -x "$script" ]]; then
            if [[ "$DEBUG" == "true" ]]; then
                echo "[INFO] Making script executable: $script"
            fi
            chmod +x "$script"
        fi

        if [[ "$DEBUG" == "true" ]]; then
            echo "[INFO] Running script: $script"
            echo "-----------------------------------"
        fi
        
        # Execute the script
        "$script"
    done
}

