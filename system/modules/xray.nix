{ config, ... }:
{
  imports = [ ./tun2xray.nix ];

  services.tun2socks = {
    enable = true;
    interface = "tun0";
    proxy = "socks5://127.0.0.1:10808";
    whitelist = [
      "www.jetbrains.com"
      "download.jetbrains.com"
      "plugins.jetbrains.com"
      "account.jetbrains.com"
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
    settingsFile = config.age.secrets.xray.path; # Key change: Use path directly
  };
}
