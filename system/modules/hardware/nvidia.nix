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
  services.xserver.videoDrivers = [
    "nvidia"
  ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
    powerManagement.finegrained = true;
  };
}
