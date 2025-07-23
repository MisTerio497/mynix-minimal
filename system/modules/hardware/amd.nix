{ pkgs, ... }:
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

}
