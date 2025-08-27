{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # System modules
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User packages and config
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    # Delete in future
    # nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    # nix-proton-cachyos.url = "github:ewtodd/nix-proton-cachyos";
    # winapps = {
    #   url = "github:winapps-org/winapps";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # lsfg-vk-flake = {
    #   url = "github:pabloaul/lsfg-vk-flake/main";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nix-photogimp3 = {
    #   url = "github:3nol/nix-photogimp3";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    youtube-music = {
      url = "github:h-banii/youtube-music-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Utilities
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      disko,
      nix-flatpak,
      flake-programs-sqlite,
      agenix,
      stylix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "ivan";
      hostname = "asus";

      # Создаем pkgs с поддержкой overlays
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      lib = nixpkgs.lib;
      specialArgs = {
        inherit
          inputs
          username
          hostname
          pkgs-unstable
          ;
      };
    in
    {
      nixosConfigurations = {
        ${hostname} = lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            flake-programs-sqlite.nixosModules.programs-sqlite
            agenix.nixosModules.default
            #sops-nix.nixosModules.sops
            nixos-hardware.nixosModules.asus-fa507nv
            ./systems/asus/configuration.nix
            ./disko.nix
          ];
        };

        homelab = lib.nixosSystem {
          inherit system;
          modules = [
            flake-programs-sqlite.nixosModules.programs-sqlite
            #sops-nix.nixosModules.sops
            ./systems/homelab/configuration.nix
          ];
        };
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [
          stylix.homeModules.stylix
          nix-flatpak.homeManagerModules.nix-flatpak
          ./user/home.nix
        ];
      };
    };
}
