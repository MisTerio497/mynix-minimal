{ config, username, ... }:
{
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
    settings = builtins.fromJSON (builtins.readFile (config.age.secrets.sing-box.path));
  };
}
