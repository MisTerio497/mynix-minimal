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
  #boot.blacklistedKernelModules = [ "nouveau" ];
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
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
  };
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    amdgpuBusId = "PCI:35:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  environment.variables = {
    __NV_PRIME_RENDER_OFFLOAD = "0"; # По умолчанию AMD
    __GLX_VENDOR_LIBRARY_NAME = "mesa"; # Mesa для AMD
  };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # Фикс курсора в Wayland
  };
}
