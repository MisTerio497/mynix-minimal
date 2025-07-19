{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;
    open = false;
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
    # powerManagement = {
    #   enable = true;
    #   finegrained = false;
    # };
    prime = {
      offload = {
        enable = lib.mkForce true;
        enableOffloadCmd = true;
      };
      reverseSync.enable = true;
      # Enable if using an external GPU
      allowExternalGpu = false;
      sync.enable = false;
      amdgpuBusId = "PCI:53:0:0"; # Converted from 35:00.0
      nvidiaBusId = "PCI:1:0:0"; # Converted from 01:00.0
    };
  };
}
