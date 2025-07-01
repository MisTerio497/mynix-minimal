#vless://dc5c8840-db66-4e0f-a545-3efdd1e2c906@91.184.240.220:443?type=tcp&security=reality&pbk=zolckHfay7174cQMkrfNGLJh0VSAWEhXqC8vJmhW1SI&fp=chrome&sni=cloudflare.com&sid=d8e05c5982&spx=%2F&flow=xtls-rprx-vision#ca26err9
{ config, pkgs, ... }:
{
  imports = [ ./tun2xray.nix ];

  services.tun2socks = {
    enable = true;
    interface = "mytun0";
    proxy = "socks5://127.0.0.1:10808";
    whitelist = [
      "jetbrains.com"
      "www.jetbrains.com"
      "download.jetbrains.com"
      "plugins.jetbrains.com"
      "account.jetbrains.com"
      "data.services.jetbrains.com"
    ];
    extraArgs = [
      "--loglevel"
      "debug"
    ];
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
                address = "91.184.240.220";
                port = 443;
                users = [
                  {
                    id = "dc5c8840-db66-4e0f-a545-3efdd1e2c906";
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
              publicKey = "zolckHfay7174cQMkrfNGLJh0VSAWEhXqC8vJmhW1SI";
              shortId = "d8e05c5982";
              spiderX = "/";
            };
          };
        }
      ];
    };
  };
}
