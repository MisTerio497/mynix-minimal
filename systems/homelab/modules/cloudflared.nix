{ pkgs, ...}:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "" = { # id tunnel
        credentialsFile = ""; # json path 
        ingress = {
          "npm.amegacloud.ru" = {
            service = "http://localhost:81";
            # path = "/*.(jpg|png|css|js)";
          };
        };
        default = "http_status:404";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    cloudflared
  ];
}
