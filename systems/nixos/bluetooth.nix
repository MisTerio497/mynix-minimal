{ ... }: {
  # Включить сервис Bluetooth
  hardware.bluetooth.enable = true;
  boot.kernelModules = [ "btusb" ];
}
