#!/usr/bin/env bash

THEME_NAME="Papiwaita"
DEST_DIR="$HOME/.local/share/icons"

usage() {
cat << EOF
  Usage: $0 [OPTIONS...]
  
  -d, --dest DIR     Specify destination directory (Default: $HOME/.local/share/icons)
  -r, --remove       Remove/Uninstall Papiwaita icon theme
  -h, --help         Show help

  Example: ./install.sh -d ~/.local/share/icons
EOF
}

install() {
  local dest=${1}
  local THEME_DIR="${dest}/${THEME_NAME}"

  echo "Installing '${THEME_DIR}'..."

  # Check if Papirus-Dark is installed
  if [ ! -d "/usr/share/icons/Papirus-Dark" ]; then
    echo "Error: Papirus-Dark icon theme not found!"
    echo "Please install it first: sudo apt install papirus-icon-theme"
    exit 1
  fi

  # Remove existing installation
  [[ -d "${THEME_DIR}" ]] && rm -rf "${THEME_DIR}"

  # Create theme directory
  mkdir -p "${THEME_DIR}"

  # Copy index.theme
  cp -r "$(dirname "$0")/index.theme" "${THEME_DIR}"

  # Copy Papirus-Dark app icons
  echo "Copying Papirus-Dark app icons..."
  for size in 16x16 22x22 24x24 32x32 48x48 64x64; do
    cp -r "/usr/share/icons/Papirus-Dark/${size}" "${THEME_DIR}/"
  done

  # Override with Adwaita symbolic system icons
  echo "Applying Adwaita symbolic system icons..."
  cp -r "/usr/share/icons/Adwaita/symbolic" "${THEME_DIR}/"

  # Update icon cache
  echo "Updating icon cache..."
  gtk-update-icon-cache -f "${THEME_DIR}"

  echo "Done! Apply Papiwaita in GNOME Tweaks under Icons."
}

remove() {
  local dest=${1}
  local THEME_DIR="${dest}/${THEME_NAME}"

  if [[ -d "${THEME_DIR}" ]]; then
    rm -rf "${THEME_DIR}"
    echo "Papiwaita icon theme removed successfully."
  else
    echo "Papiwaita icon theme not found in ${dest}."
  fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "${1}" in
    -d|--dest)
      DEST_DIR="${2}"
      shift 2
      ;;
    -r|--remove)
      remove "${DEST_DIR}"
      exit 0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: ${1}"
      usage
      exit 1
      ;;
  esac
done

install "${DEST_DIR}"
