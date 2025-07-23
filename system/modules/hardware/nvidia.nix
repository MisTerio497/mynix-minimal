{
  config,
  lib,
  ...
}:

{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  services.xserver.enable = true;
  services.xserver.videoDrivers = [
    "nvidia"
  ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;
    open = false;
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
  };
}
