{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  boot = {
    loader = {
      systemd-boot = {
        enable = lib.mkForce true;
        consoleMode = "max";
      };
      efi = {
        canTouchEfiVariables = true;
        #efiSysMountPoint = "/boot/efi";
      };
    };
    kernelPackages = pkgs.linuxPackages_zen;
    plymouth = {
      enable = true;
      themePackages = [ pkgs.catppuccin-plymouth ];
      theme = "catppuccin-macchiato";
    };
    kernelParams = [
      "quiet"
      "splash"
      # "boot.shell_on_fail"
      # "udev.log_priority=3"
      # "rd.systemd.show_status=auto"
    ];
    supportedFilesystems = [ "ntfs" ];
    initrd = {
      enable = true;
      verbose = false;
      systemd.enable = true;
    };
    consoleLogLevel = 3;
  };
}
