{ pkgs, lib, config, ... }:
{
  networking = {
    hostName = "nixos";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    extraHosts = "
    # JetBrains:
    50.7.85.221 datalore.jetbrains.com
    107.150.34.100 plugins.jetbrains.com
    185.246.223.127 download.jetbrains.com
    185.246.223.127 api.jetbrains.ai
    185.246.223.127 account.jetbrains.com";
    proxy = {
      # allProxy = if config.services.sing-box.enable then "socks5://127.0.0.1:10808" else "";
      noProxy = "127.0.0.1,localhost,.local,.ru,nixos.org,cachix.org";
    };
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      
      ensureProfiles.profiles = {
        RT-5GPON-4957 = {
          connection = {
            id = "RT-5GPON-4957";
            type = "wifi";
            autoconnect = true;
          };
          wifi = {
            ssid = "RT-5GPON-4957";
            mode = "infrastructure";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "4FmW9pVw";
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
          connection.priority = 100;
        };

        RT-GPON-4957 = {
          connection = {
            id = "RT-GPON-4957";
            type = "wifi";
            autoconnect = true;
          };
          wifi = {
            ssid = "RT-GPON-4957";
            mode = "infrastructure";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "4FmW9pVw";
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
        };

        RT-WiFi_AF2F = {
          connection = {
            id = "RT-WiFi_AF2F";
            type = "wifi";
            autoconnect = true;
          };
          wifi = {
            ssid = "RT-WiFi_AF2F";
            mode = "infrastructure";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "cDUE4UE3";
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
        };

        Amogus2 = {
          connection = {
            id = "Amogus";
            type = "wifi";
            autoconnect = true;
          };
          wifi = {
            ssid = "Amogus";
            mode = "infrastructure";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "12345678ggawp";
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
        };

        bliznetsy = {
          connection = {
            id = "bliznetsy";
            type = "wifi";
            autoconnect = true;
          };
          wifi = {
            ssid = "bliznetsy";
            mode = "infrastructure";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "55557777";
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
        };
      };
    };
    # wireless = {
    #   enable = false;
    #   networks = {
    #     "RT-5GPON-4957" = {
    #       psk = "4FmW9pVw";
    #       priority = 100;
    #     };
    #     "RT-GPON-4957" = {
    #       psk = "4FmW9pVw";
    #     };
    #     "RT-WiFi_AF2F" = {
    #       psk = "cDUE4UE3";
    #     };
    #     "Amogus" = {
    #       psk = "12345678ggawp";
    #     };
    #     "bliznetsy" = {
    #       psk = "55557777";
    #     };
    #   };
    # };
  };
}
