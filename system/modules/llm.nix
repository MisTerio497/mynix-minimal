{ pkgs, config, ... }:

{

  services.ollama = {
    enable = true;
    loadModels = [ "llama3.2:3b" "qwen3:4b" ];
    acceleration = "cuda";
  };

  # services.searx = {
  #   enable = true;
  #   settings = {
  #     server = {
  #       port = 7777;
  #       bind_address = "127.0.0.1";
  #       secret_key = "@SEARX_SECRET_KEY@"; # FIXME: Set up this key in the .env file described below, name of variable `SEARX_SECRET_KEY`
  #     };
  #     search = {
  #       formats = [ "html" "json" ];
  #     };
  #   };
  #   environmentFile = "${config.users.users.xnm.home}/.config/.env.searxng"; # FIXME: The location of the `.env` file where you need to set up the key
  # };

  services.open-webui = {
    enable = true;
    port = 8888;
    host = "127.0.0.1";
  };
  
  # environment.systemPackages = with pkgs; [
  #   oterm
  #   alpaca
  #   aichat
  #   fabric-ai
  #   aider-chat

  #   # tgpt
  #   # smartcat
  #   # nextjs-ollama-llm-ui
  #   # open-webui
  # ];
}