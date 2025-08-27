{ pkgs, lib, ... }:
{

  services.zerotierone.enable = true;
  networking = {
    hostName = "nixos";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    nftables.enable = true;
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

        Amogus = {
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
    wireless = {
      enable = false;
      networks = {
        "RT-5GPON-4957" = {
          psk = "4FmW9pVw";
          priority = 100;
        };
        "RT-GPON-4957" = {
          psk = "4FmW9pVw";
        };
        "RT-WiFi_AF2F" = {
          psk = "cDUE4UE3";
        };
        "Amogus" = {
          psk = "12345678ggawp";
        };
        "bliznetsy" = {
          psk = "55557777";
        };
      };
    };
    firewall = {
      enable = false;
    };
  };
}
