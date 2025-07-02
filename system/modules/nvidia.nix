{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    # amdgpu.amdvlk = {
    #   enable = true;
    #   support32Bit.enable = true;
    # };
  };
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    nvidiaSettings = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      sync.enable = false;
      amdgpuBusId = "PCI:53:0:0"; # Converted from 35:00.0
      nvidiaBusId = "PCI:1:0:0"; # Converted from 01:00.0
    };
  };
}
