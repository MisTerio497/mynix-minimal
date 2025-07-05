{ pkgs, inputs, ... }:
{
  # imports = [
  #   inputs.nixos-boot.nixosModules.default
  # ];
  # nixos-boot = {
  #   enable = false;
  #   # theme = "evil-nixos";
  #   # bgColor.red   = 0; # 0 - 255
  #   # bgColor.green = 0; # 0 - 255
  #   # bgColor.blue  = 0; # 0 - 255
  #   #duration = 3;
  # };
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    plymouth = {
      enable = true;
      font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
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
    supportedFilesystems = [ "ntfs" ];
    initrd = {
      enable = true;
      verbose = false;
      systemd.enable = true;
    };
    consoleLogLevel = 3;
  };
}
