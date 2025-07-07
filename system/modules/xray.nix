{ config, pkgs, ... }:
let
  raw = config.age.secrets.xray.path;
in
{
  imports = [ ./tun2xray.nix ];

  services.tun2socks = {
    enable = true;
    interface = "tun0";
    proxy = "socks5://127.0.0.1:10808";
    whitelist = [
      # JetBrains domains
      "download.jetbrains.com"
      "plugins.jetbrains.com"
      "account.jetbrains.com"

      # Discord domains
      "discord.com"
      "*.discord.com"
      "*.discord.gg"
      "*.discordapp.com"
      "*.discordapp.net"

      # Discord media and WebSocket
      "cdn.discordapp.com"
      "media.discordapp.net"

      # Discord API and gateway
      "gateway.discord.gg"
      "discord-api.com"
    ];
  };

  age = {
    identityPaths = [ "/home/ivan/.age/keys.txt" ];
    secrets.xray = {
      file = ./secrets/xray-secrets.age;
      owner = "ivan";
      group = "users";
      mode = "0400";
    };
  };

  services.xray = {
    enable = true;
    settings =
      let
        secrets = builtins.fromJSON (builtins.readFile raw);
      in
      {
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
