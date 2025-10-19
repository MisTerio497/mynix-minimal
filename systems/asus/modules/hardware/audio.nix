{ pkgs, ... }:

{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    # Low latency config
    # extraConfig.pipewire."92-low-latency" = {
    #   "context.properties" = {
    #     "default.clock.rate" = 96000;
    #     "default.clock.quantum" = 256;
    #   };
    # };
  };
}
