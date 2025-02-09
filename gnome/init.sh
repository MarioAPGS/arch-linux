DIR="gnome/"
source "${ROOT_DIR}/utils/menu_launcher.sh"

# install yay
source "${ROOT_DIR}/${DIR}/install_yay.sh"

# remove preinstalled packages
SCRIPT_PATH="${ROOT_DIR}/${DIR}"
OPTIONS=(
    "remove_gnome_packages"
    "install_packages" 
    "install_bluetooth"
    "shortcuts/init"
)
QUESTION="Which actions do you want to take?"
exec_scripts "$SCRIPT_PATH" OPTIONS[@] "$QUESTION"

# Console selector
source "${ROOT_DIR}/console/init.sh"