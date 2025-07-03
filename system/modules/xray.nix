{ config, pkgs, ... }:
let
  # Получаем путь к секрету через конфиг NixOS
  raw = builtins.readFile config.age.secrets.xray.path;
  secrets = import (builtins.toFile "decoded.nix" raw);
in
{
  imports = [ ./tun2xray.nix ];

  services.tun2socks = {
    enable = true;
    interface = "tun0";
    proxy = "socks5://127.0.0.1:10808";
    whitelist = [
      "jetbrains.com"
      "www.jetbrains.com"
      "download.jetbrains.com"
      "plugins.jetbrains.com"
      "account.jetbrains.com"
      "data.services.jetbrains.com"
      "discord.com"
    ];
  };
  

  age.identityPaths = [ "/home/ivan/.config/age/keys.txt" ];
  age.secrets.xray = {
    file = ./secrets/xray-secrets.age;
    owner = "ivan";
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
