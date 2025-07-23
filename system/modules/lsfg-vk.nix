{ inputs, ... }:
{
  modules = [
    inputs.lsfg-vk-flake.nixosModules.default
  ];
  services.lsfg-vk = {
    enable = false;
  };
}
