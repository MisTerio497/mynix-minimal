#!/usr/bin/env bash
set -euo pipefail

# Функция выбора диска с валидацией
choose_disk() {
  echo "Доступные диски:"
  lsblk -d -o NAME,SIZE,MODEL,TRAN,ROTA | grep -v "NAME"
  
  while true; do
    read -p "Введите имя диска (например nvme0n1 или sda): " DISK
    DISK="/dev/${DISK}"
    
    # Проверка существования диска
    if [[ ! -e "$DISK" ]]; then
      echo "Ошибка: диск $DISK не существует!"
      continue
    fi
    
    # Проверка, что это не системный диск LiveCD
    if mount | grep -q "$DISK"; then
      echo "Ошибка: диск $DISK содержит смонтированные разделы (возможно, это LiveCD?)"
      continue
    fi
    
    # Подтверждение выбора
    read -p "Вы уверены, что хотите использовать $DISK? Все данные будут удалены! (y/N): " confirm
    if [[ "${confirm,,}" =~ ^(y|yes)$ ]]; then
      break
    fi
  done
}

# Основной процесс
choose_disk

# Копирование конфигурации
CONFIG_DIR="/mnt/etc/nixos"
echo "Копируем конфигурацию в $CONFIG_DIR..."
mkdir -p "$CONFIG_DIR"
cp -r . "$CONFIG_DIR"

# Форматирование диска
echo "Форматируем диск $DISK..."
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- \
  --mode zap_create_mount \
  "$CONFIG_DIR/disko.nix" \
  --disk "$DISK"

# Генерация hardware-configuration.nix
echo "Генерируем hardware-configuration.nix..."
nixos-generate-config --show-hardware-config --no-filesystems > "$CONFIG_DIR/hardware-configuration.nix"

# Установка системы
echo "Начинаем установку NixOS..."
nixos-install --flake "$CONFIG_DIR#nixos" --root /mnt --no-root-passwd

echo "Установка завершена! Система будет перезагружена через 5 секунд..."
sleep 5
reboot
