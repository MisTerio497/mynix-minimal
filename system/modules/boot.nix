{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    #./secureboot.nix
  ];
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi = {
        canTouchEfiVariables = true;
        #efiSysMountPoint = "/boot/efi";
      };
    };

    kernelPackages = pkgs.linuxPackages_latest;
    plymouth = {
      enable = true;
      themePackages = [ pkgs.catppuccin-plymouth ];
      theme = "catppuccin-macchiato";
    };
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    supportedFilesystems = [ "ntfs" "ext4" "exfat" "vfat"];
    initrd = {
      enable = true;
      verbose = false;
      systemd.enable = true;
    };
    consoleLogLevel = 3;
  };
}
