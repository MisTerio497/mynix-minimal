{ config, username, ... }:
{
  age = {
    identityPaths = [ "/home/${username}/.age/keys.txt" ];
    secrets = {
    xray = {
      file = ./secrets/xray-secrets.age;
    };
    sing-box = {
      file = ./secrets/sing-box-secrets.age;
    };
    };
  };
  

#   services.xray = {
#     enable = true;
#     settingsFile = config.age.secrets.xray.path;
#   };
}
