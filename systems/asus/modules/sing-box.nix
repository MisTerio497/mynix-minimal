{ config, username, ... }:
{
  imports = [
    ./sing-box-new.nix
  ];
  
  age = {
    identityPaths = [ "/home/${username}/.age/keys.txt" ];
    secrets = {
      sing-box = {
        file = ./secrets/sing-box-secrets.age;
      };
    };
  };
  services.sing-box = {
    enable = true;
    settingsFile = config.age.secrets.sing-box.path;
  };
}
