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
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    nvidiaSettings = true;
    prime = {
      offload = {
        enable = lib.mkForce true;
        enableOffloadCmd = true;
      };
      sync.enable = lib.mkForce false;
      amdgpuBusId = "PCI:53:0:0"; # Converted from 35:00.0
      nvidiaBusId = "PCI:1:0:0"; # Converted from 01:00.0
    };
  };
  environment.variables = {
    __NV_PRIME_RENDER_OFFLOAD = "0";  # По умолчанию AMD
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
  };
}