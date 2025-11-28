{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # System modules
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-fonts = {
      url= "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # User packages and config
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zed.url = "github:zed-industries/zed";
    # Utilities
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      # nixpkgs-unstable,
      home-manager,
      disko,
      nix-flatpak,
      flake-programs-sqlite,
      agenix,
      ...
    }@inputs:
    let
      username = "ivan";
      hostname = "asus";
      system = "x86_64-linux";

      # Создаем pkgs с поддержкой overlays
      pkgs = nixpkgs.legacyPackages.${system};
      # pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      lib = nixpkgs.lib;
      specialArgs = {
        inherit
          inputs
          # pkgs-unstable
          username
          hostname
          ;
      };
    in
    {
      nixosConfigurations = {
        asus = lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            flake-programs-sqlite.nixosModules.programs-sqlite
            agenix.nixosModules.default
            ./systems/asus/configuration.nix
            ./disko.nix
          ];
        };

        homelab = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            flake-programs-sqlite.nixosModules.programs-sqlite
            agenix.nixosModules.default
            ./systems/homelab/configuration.nix
          ];
        };
      };

      homeConfigurations.ivan = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [
          nix-flatpak.homeManagerModules.nix-flatpak
          ./user/home.nix
        ];
      };
    };
}
