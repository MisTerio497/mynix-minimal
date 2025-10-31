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
    powerManagement.enable = true;
    dynamicBoost.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
