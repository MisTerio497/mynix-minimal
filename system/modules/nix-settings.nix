{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly"; # Очистка раз в неделю
      options = "--delete-older-than 7d"; # Удалить всё старше 7 дней
    };
    settings = {
      warn-dirty = false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://winapps.cachix.org"
        "https://cachix.org/api/v1/cache/wine"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g="
        "wine.cachix.org-1:6hEYg6JbQ9ZQ6bFSQZx1z6QdCbY50q1T6K3XV8ZQ6b8="
      ];
    };
  };
}