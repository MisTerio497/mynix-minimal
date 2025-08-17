{
  nix = {
    channel.enable = false;
    gc = {
      automatic = true;
      dates = "weekly"; # Очистка раз в неделю
      options = "--delete-older-than 7d"; # Удалить всё старше 7 дней
    };
    settings = {
      warn-dirty = false;
      download-buffer-size = 524288000;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}