{pkgs, ...}:
{
  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };
    efi.canTouchEfiVariables = true;
  };
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelParams = [
    # Уменьшить уровень логов ACPI
    "loglevel=4" # 3 (только ошибки), 4 (предупреждения + ошибки)
    "quiet" # скрыть большинство сообщений ядра
  ];
}