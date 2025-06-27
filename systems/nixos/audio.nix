{
  security.rtkit.enable = true;  # Включает RTKit
  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
}