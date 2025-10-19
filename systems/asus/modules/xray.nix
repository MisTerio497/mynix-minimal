{ config, username, ... }:
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
    identityPaths = [ "/home/${username}/.age/keys.txt" ];
    secrets.xray = {
      file = ./secrets/xray-secrets.age;
    };
  };

  services.xray = {
    enable = true;
    settingsFile = config.age.secrets.xray.path;
  };
}
