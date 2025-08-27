{ lib, ...}:
{
  hardware.nvidia = {
    prime = {
      amdgpuBusId = lib.mkForce "PCI:53:0:0"; # Converted from 35:00.0
      nvidiaBusId = lib.mkForce "PCI:1:0:0"; # Converted from 01:00.0
    };
  };
}