{ lib, ...}:
{
  hardware.nvidia = {
    prime = {
      offload = {
        enable = lib.mkForce true;
        enableOffloadCmd = true;
      };
      # reverseSync.enable = true;
      # allowExternalGpu = false;
      sync.enable = false;
      amdgpuBusId = "PCI:53:0:0"; # Converted from 35:00.0
      nvidiaBusId = "PCI:1:0:0"; # Converted from 01:00.0
    };
  };
}