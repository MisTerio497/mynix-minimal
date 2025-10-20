# age --decrypt --identity ~/.age/keys.txt --output output.txt xray-secrets.age
# age -r $(cat ~/.age/public-key.txt) config.json > sing-box-secrets.age
{ config, username, ... }:
{
  age = {
    identityPaths = [ "/home/${username}/.age/keys.txt" ];
    secrets = {
      xray = {
        file = ./secrets/xray-secrets.age;
      };
    };
  };

  services.xray = {
    enable = true;
    settingsFile = config.age.secrets.xray.path;
  };
}
