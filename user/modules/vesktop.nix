{
  programs.vesktop = {
    enable = true;
    settings = {
      appBadge = false;
      arRPC = true;
      checkUpdates = false;
      customTitleBar = false;
      disableMinSize = true;
      minimizeToTray = true;
      hardwareAcceleration = true;
      discordBranch = "stable";
    };
  };
  xdg.desktopEntries = {
    vesktop = {
      name = "Vencord Desktop";
      exec = "vesktop --disable-gpu-sandbox --proxy-server=socks5://127.0.0.1:10808";
      icon = "vesktop";
      type = "Application";
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      settings = {
        StartupWMClass = "vesktop";
      };
    };
  };
}
