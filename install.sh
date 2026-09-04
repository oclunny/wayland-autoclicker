#!/usr/bin/env bash
# One-shot installer for wayland-autoclicker.
# Run this from inside the cloned repo: ./install.sh
set -e

BIN_DIR="$HOME/.local/bin"
TARGET="$BIN_DIR/autoclicker.sh"

echo "==> Checking for ydotool..."
if ! command -v ydotool >/dev/null 2>&1; then
    echo "ydotool not found."
    if command -v yay >/dev/null 2>&1; then
        echo "Installing with yay..."
        yay -S --noconfirm ydotool
    elif command -v pacman >/dev/null 2>&1; then
        echo "Installing with pacman..."
        sudo pacman -S --noconfirm ydotool
    elif command -v apt >/dev/null 2>&1; then
        echo "Installing with apt..."
        sudo apt install -y ydotool
    else
        echo "Could not auto-install ydotool on this distro."
        echo "Please install it manually, then re-run this script."
        exit 1
    fi
else
    echo "ydotool already installed."
fi

echo "==> Copying script to $TARGET"
mkdir -p "$BIN_DIR"
cp "$(dirname "$0")/autoclicker.sh" "$TARGET"
chmod +x "$TARGET"

echo "==> Adding $USER to the 'input' group (needed for uinput access)"
if groups "$USER" | grep -qw input; then
    echo "Already in the input group."
else
    sudo usermod -aG input "$USER"
    echo "Added. You must log out and back in for this to take effect."
fi

echo "==> Enabling ydotool user service"
systemctl --user enable --now ydotool.service

echo ""
echo "Done."
echo "Script installed at: $TARGET"
echo ""
echo "Next steps:"
echo "  1. If you were just added to the 'input' group, log out and back in."
echo "  2. Test it directly: ydotool click 0xC0"
echo "  3. Bind $TARGET to a global hotkey in your desktop's shortcut settings."
echo "     (See README.md for KDE Plasma instructions.)"
