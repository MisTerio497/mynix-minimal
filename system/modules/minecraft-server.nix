{ pkgs, lib, ...}:
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    
    dataDir = "/home/ivan/atdm";
    package = pkgs.papermcServers.papermc-1_21_8;
    openFirewall = true;
    # whitelist = {
    #   # This is a mapping from Minecraft usernames to UUIDs. You can use https://mcuuid.net/ to get a Minecraft UUID for a username
    #   username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    #   username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
    # };
    serverProperties = {
      server-port = 43000;
      difficulty = 3;
      gamemode = 1;
      max-players = 5;
      motd = "NixOS Minecraft server!";
      white-list = true;
      allow-cheats = true;
    };
    
    jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
  };
}