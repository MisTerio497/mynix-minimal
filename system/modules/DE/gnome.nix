{ pkgs, ...}:
{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver = {
      enable = true;
      desktopManager.gnome = {
        enable = true;
      };
    };
  environment.gnome.excludePackages = ( with pkgs; [
          gnome-tour       # Исключить GNOME Tour
          epiphany         # Исключить веб-браузер Epiphany
          gnome-connections # Исключить удалённые подключения
          gnome-contacts   # Исключить контакты
          gnome-maps      # Исключить карты
          gnome-weather   # Исключить погоду
          gnome-music     # Исключить музыку
          cheese          # Исключить Cheese (веб-камера)
        ]);
  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "ivan";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
