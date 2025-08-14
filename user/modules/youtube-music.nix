{
  inputs,
  username,
  ...
}:
{
  imports = [
    inputs.youtube-music.homeManagerModules.default
  ];
  programs.youtube-music = {
    enable = true;
    options = {
      tray = true;
      language = "ru";
      removeUpgradeButton = true;
      proxy = "socks5://127.0.0.1:10808";
      startingPage = "Home";
    };
    plugins = {
      adblocker.enabled = true;
    };
  };

  xdg.desktopEntries.youtube-music = {
    name = "YouTube Music";
    genericName = "Music Player";
    comment = "A desktop client for YouTube Music with plugin support";
    exec = "youtube-music --user-data-dir=/home/${username}/.config/youtube-music";
    icon = "youtube-music";
    type = "Application";
    categories = [
      "AudioVideo"
      "Player"
      "Music"
    ];
    settings = {
      StartupWMClass = "youtube-music";
    };
  };

}
