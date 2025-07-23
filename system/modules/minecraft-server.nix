{ pkgs, lib, inputs, ... }:

{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true; # Автоматически принимает EULA
    dataDir = "/var/lib/minecraft/atdm"; # Лучше использовать /var/lib для серверных данных
    
    servers.atdm = {
      enable = true;
      package = pkgs.papermcServers.papermc-1_21_5;
      openFirewall = true;

      # Если нужны плагины, добавьте их так:
      symlinks = {
        plugins = pkgs.linkFarm "atdm-plugins" [
        ];
      };

      serverProperties = {
        server-port = 43000;
        difficulty = "hard"; # вместо 3
        gamemode = "creative"; # вместо 1
        max-players = 5;
        motd = "NixOS Minecraft server!";
        enable-command-block = true; # вместо allow-cheats
        white-list = false;
        online-mode = true; # важно для безопасности
        view-distance = 10;
        simulation-distance = 8;
      };

      jvmOpts = lib.concatStringsSep " " [
        "-Xms4G" # Более читаемый формат
        "-Xmx4G"
        "-XX:+UseG1GC"
        "-XX:+ParallelRefProcEnabled"
        "-XX:MaxGCPauseMillis=200"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+DisableExplicitGC"
        "-XX:+AlwaysPreTouch"
        "-XX:G1NewSizePercent=30"
        "-XX:G1MaxNewSizePercent=40"
        "-XX:G1HeapRegionSize=8M"
        "-XX:G1ReservePercent=20"
        "-XX:G1HeapWastePercent=5"
        "-XX:G1MixedGCCountTarget=4"
        "-XX:InitiatingHeapOccupancyPercent=15"
        "-XX:G1MixedGCLiveThresholdPercent=90"
        "-XX:G1RSetUpdatingPauseTimePercent=5"
        "-XX:SurvivorRatio=32"
        "-XX:+PerfDisableSharedMem"
        "-XX:MaxTenuringThreshold=1"
        "-Dusing.aikars.flags=https://mcflags.emc.gs"
        "-Daikars.new.flags=true"
      ];
    };
  };
}