{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.network-connections;
in {
  options.networking.network-connections = {
    enable = mkEnableOption "Enable custom NetworkManager connections";

    wifi = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption { type = types.str; };
          ssid = mkOption { type = types.str; };
          password = mkOption { type = types.str; };
          priority = mkOption { type = types.int; default = 0; };
        };
      });
      default = [];
      description = "List of Wi-Fi connections";
    };

    ethernet = mkOption {
      type = types.listOf (types.str);
      default = [];
      description = "List of Ethernet connections";
    };
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;

    systemd.services.network-connections = {
      wantedBy = [ "network.target" ];
      serviceConfig.Type = "oneshot";
      script = let
        nmcli = "${pkgs.networkmanager}/bin/nmcli";
      in ''
        # Удаляем старые подключения (опционально)
        ${nmcli} --terse --fields NAME connection show | while read -r conn; do
          ${nmcli} connection delete "$conn"
        done

        # Добавляем Wi-Fi
        ${concatMapStringsSep "\n" (wifi: ''
          ${nmcli} connection add \
            type wifi \
            con-name "${wifi.name}" \
            ifname "*" \
            ssid "${wifi.ssid}" \
            wifi-sec.key-mgmt wpa-psk \
            wifi-sec.psk "${wifi.password}" \
            connection.autoconnect-priority ${toString wifi.priority} \
            connection.autoconnect yes
        '') cfg.wifi}

        # Добавляем Ethernet (если нужно)
        ${concatMapStringsSep "\n" (eth: ''
          ${nmcli} connection add \
            type ethernet \
            con-name "${eth}" \
            ifname "${eth}" \
            connection.autoconnect yes
        '') cfg.ethernet}
      '';
    };
  };
}