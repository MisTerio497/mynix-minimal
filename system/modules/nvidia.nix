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
  boot.blacklistedKernelModules = [ "nouveau" ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ vaapiVdpau ];
    };
    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
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
        enable = false;
        enableOffloadCmd = false;
      };
      sync.enable = true;
      amdgpuBusId = "PCI:53:0:0"; # Converted from 35:00.0
      nvidiaBusId = "PCI:1:0:0"; # Converted from 01:00.0
    };
  };
}
