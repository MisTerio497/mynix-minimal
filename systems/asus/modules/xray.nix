{ config, ... }:
{
  #imports = [ ./tun2xray.nix ];

  # services.tun2socks = {
  #   enable = true;
  #   interface = "jetbrain-tun0";
  #   proxy = "socks5://127.0.0.1:10808";
  #   whitelist = [
  #     "download.jetbrains.com"
  #     "download-cdn.jetbrains.com"
  #     # Можно добавить и другие, если нужно:
  #     # "www.jetbrains.com"
  #     # "account.jetbrains.com"
  #   ];
  # };

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
