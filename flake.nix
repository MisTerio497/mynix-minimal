{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-boot.url = "github:Melkor333/nixos-boot";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # illogical-impulse = {
    #   url = "github:bigsaltyfishes/end-4-dots";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      disko,
      stylix,
      flake-programs-sqlite,
      agenix,
      nixos-hardware,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./system/configuration.nix
          ./disko.nix
          flake-programs-sqlite.nixosModules.programs-sqlite
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          #nixos-hardware.nixosModules.asus-fa507nv
          {
            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = false;
              backupFileExtension = "bak";
              extraSpecialArgs = { inherit inputs; };
              users.ivan = {
                imports = [
                  ./user/home.nix
                  stylix.homeModules.stylix
                ];
              };
            };
          }
        ];
      };
    };
}
