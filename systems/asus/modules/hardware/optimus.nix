{ lib, config, ... }:
{
  services.xserver.videoDrivers = [
    "nvidia"
  ];
  services.supergfxd.enable = true;
  services.supergfxd.settings = {
    mode = "Hybrid";
    vfio_enable = false;
    hotplug_type = "None";
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    dynamicBoost.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
