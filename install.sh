#!/usr/bin/env bash
set -euo pipefail

# Копирование конфигурации
HOST="mininal"
CONFIG_DIR="/mnt/etc/nixos"
echo "Копируем конфигурацию в $CONFIG_DIR..."
mkdir -p "$CONFIG_DIR"
cp -r * "$CONFIG_DIR"

# Генерация hardware-configuration.nix
echo "Генерируем hardware-configuration.nix..."
nixos-generate-config --show-hardware-config --no-filesystems > "$CONFIG_DIR/systems/$HOST/hardware-configuration.nix"

# Установка системы
echo "Начинаем установку NixOS..."
nixos-install --flake "$CONFIG_DIR#$HOST" --root /mnt --no-root-passwd
sudo rm -r /mnt/root/.nix-defexpr/channels /mnt/nix/var/nix/profiles/per-user/root/channels


echo "Установка завершена! Система будет перезагружена через 5 секунд..."
sleep 5
reboot
