{
  inputs,
  ...
}:
{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];
  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [ "ru.linux_gaming.PortProton" ];
    update.auto = {
      enable = true;
      onCalendar = "weekly"; # Default value
    };
  };
}
