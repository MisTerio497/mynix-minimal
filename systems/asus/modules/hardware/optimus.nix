{ lib, config, ... }:
{
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];
  services.supergfxd.enable = true;
  services.supergfxd.settings = {
    mode = "Hybrid";
    vfio_enable = false;
    hotplug_type = "None";
  };
  hardware.nvidia = {
    forceFullCompositionPipeline = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    dynamicBoost.enable = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
