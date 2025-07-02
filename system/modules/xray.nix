
{ config, pkgs, ... }:
let
  secrets = import config.age.secrets.xray-config.path;
in {
  imports = [ ./tun2xray.nix ];

  services.tun2socks = {
    enable = false;
    interface = "tun0";
    proxy = "socks5://127.0.0.1:10808";
    whitelist = [
      "jetbrains.com"
      "www.jetbrains.com"
      "download.jetbrains.com"
      "plugins.jetbrains.com"
      "account.jetbrains.com"
      "data.services.jetbrains.com"
    ];
  };
  age.identityPaths = [ "/home/ivan/.config/age/keys.txt" ];
  age.secrets.xray-config = {
    file = ./secrets/xray-secrets.age;
    owner = "ivan";
    mode = "0400";
  };
  services.xray = {
    enable = true;
    settings = {
      log.level = "warning";

      inbounds = [
        {
          listen = "127.0.0.1";
          port = 10808;
          protocol = "socks";
          settings = {
            auth = "noauth";
            udp = true;
          };
        }
      ];

      outbounds = [
        {
          protocol = "vless";
          settings = {
            vnext = [
              {
                address = secrets.address;
                port = 443;
                users = [
                  {
                    id = secrets.id;
                    flow = "xtls-rprx-vision";
                    encryption = "none";
                  }
                ];
              }
            ];
          };
          streamSettings = {
            network = "tcp";
            security = "reality";
            realitySettings = {
              serverName = "cloudflare.com";
              fingerprint = "chrome";
              publicKey = secrets.publicKey;
              shortId = secrets.shortId;
              spiderX = "/";
            };
          };
        }
      ];
    };
  };
}
