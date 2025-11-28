{
  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      # "ru.linux_gaming.PortProton"
      # "io.github.vikdevelop.SaveDesktop"
      # "com.github.tchx84.Flatseal"
      # "org.vinegarhq.Sober"
      # "io.github.Soundux"
    ];
    update.auto = {
      enable = true;
      onCalendar = "weekly"; # Default value
    };
  };
}
