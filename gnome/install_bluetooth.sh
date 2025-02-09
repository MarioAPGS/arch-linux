#!/bin/bash
# [title]: Install bluetooth
echo "[INFO] Installing Bluetooth drivers..."
sudo pacman -S --noconfirm bluez bluez-utils

echo "[INFO] Enabling and starting Bluetooth service..."
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

echo "[SUCCESS] Bluetooth drivers installed and service started."