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

  config = lib.mkIf cfg.enable {
      systemd.services.sing-box.serviceConfig.ExecStart = lib.mkAfter [
        "-c" "${cfg.settingsFile}"
      ];
    };
}
