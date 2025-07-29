{
  inputs,
  ...
}:
{
  imports = [
    inputs.youtube-music.homeManagerModules.default
  ];
  programs.youtube-music = {
    enable = true;
    proxy = "socks5://127.0.0.1:10808";
    options = {
      tray = true;
    };
    plugins = {
      
    };
  };
}
