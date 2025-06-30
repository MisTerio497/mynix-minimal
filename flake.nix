{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      disko,
      stylix,
      hyprland,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;

    in
    {
      nixosConfigurations = {
        nixos = lib.nixosSystem rec {
          inherit system;
          specialArgs = {
            inherit hyprland;
            inherit inputs;
          };
          modules = [
            ./systems/nixos/configuration.nix
            ./hardware-configuration.nix
            ./disko.nix
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.ivan = {
                  imports = [
                    ./users/ivan/home.nix
                    stylix.homeModules.stylix
                  ];
                };
              };
            }
          ];
        };
      };
    };
}
