{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.sing-box;
in
{
  options.services.sing-box.settingsFile = mkOption {
    type = types.path; # путь к файлу
    description = "Path to additional Sing-Box configuration file";
  };

  config = mkIf cfg.enable {
    systemd.services.sing-box = lib.mkForce (mkMerge [
      config.systemd.services.sing-box
      {
        serviceConfig = {
          # Дополнительно передаем файл в аргументы запуска
          ExecStart = "${cfg.package}/bin/sing-box run -c ${cfg.settingsFile}";
        };
      }
    ]);
  };
}
