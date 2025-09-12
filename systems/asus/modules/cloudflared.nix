{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "65c86c60-dbda-475c-b1db-1d12e12e4c6b" = {
        credentialsFile = "/home/ivan/.cloudflared/cert.pem";
        ingress = {
          "npm.amegacloud.ru" = "http://localhost:81";
        };
        default = "http_status:404";
      };
    };
  };
}
