# [title]: kitty
source "${ROOT_DIR}/utils/menu_launcher.sh"

function setup_zsh(){
    sudo pacman -Sy zsh lsd bat zsh-completions zsh-autosuggestions zsh-syntax-highlighting
    if [[ "$SHELL" != *"zsh" ]]; then
        chsh -s $(which zsh)
    fi
    if [[ ! -d "~/.powerlevel10k" ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
    fi
    CURRENT_DIR="$(dirname "$(realpath "$0")")"
    cat $ROOT_DIR/console/.zshrc > ~/.zshrc
    # echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
}

if ! command -v zsh &> /dev/null || [[ "$SHELL" != *"zsh" ]]; then
    echo "[WARNING] Zsh is either not installed or not in use."
    echo "[INFO] Running setup_zsh..."
    setup_zsh
fi

SCRIPT_PATH="${ROOT_DIR}/console"
OPTIONS=("kitty")
QUESTION="Do you want to install kitty?"
DEBUG="true"

exec_init "$SCRIPT_PATH" OPTIONS[@] "$QUESTION" "$DEBUG"