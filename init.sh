#!/bin/bash
export ROOT_DIR="$(dirname "$(realpath "$0")")"
source "${ROOT_DIR}/utils/menu_launcher.sh"

# Desktop selector
OPTIONS=("awesome" "gnome" "console")
QUESTION="Which desktop environment do you want to configure?"
DEBUG="true"
# the selection will execute: /{ROOT_DIR}/{SELECTION}/init.sh
exec_init "$ROOT_DIR" OPTIONS[@] "$QUESTION" "$DEBUG"
