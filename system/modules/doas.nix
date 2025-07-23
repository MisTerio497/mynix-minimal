{ pkgs, ...}:
{
  security.sudo.enable = false; # Отключаем sudo
  security.doas = {
    enable = true;
    extraRules = [
      {
        users = ["ivan"];
        groups = [ "wheel" ];
        keepEnv = true; # Сохраняет переменные окружения (важно для NixOS)
        persist = true; # Запоминает аутентификацию на время сессии
      }
    ];
    extraConfig = ''
      permit nopass :wheel as root cmd ${pkgs.git}/bin/git
      permit nopass :wheel as root cmd ${pkgs.systemd}/bin/systemctl reboot
      permit nopass :wheel as root cmd ${pkgs.systemd}/bin/systemctl poweroff
    '';
  };
}
