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

    # plymouth = {
    #   enable = true;
    #   theme = "rings";
    #   themePackages = with pkgs; [
    #     # By default we would install all themes
    #     (adi1090x-plymouth-themes.override {
    #       selected_themes = [ "rings" ];
    #     })
    #   ];
    # };
    # kernelParams = [
    #   "quiet"
    #   "splash"
    #   "boot.shell_on_fail"
    #   "udev.log_priority=3"
    #   "rd.systemd.show_status=auto"
    # ];
    supportedFilesystems = [
      "ntfs"
      "btrfs"
      "exfat"
      "vfat"
    ];
    consoleLogLevel = 3;
  };
}
