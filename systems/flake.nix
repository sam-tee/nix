{
  description = "Flake for nix hosts";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    akhlus = {
      url = "path:../.";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    mobile-nixos = {
      url = "github:mobile-nixos/mobile-nixos";
      flake = false;
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixgl.url = "github:nix-community/nixgl";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
  outputs = inputs @ {...}: let
    inherit (import ./helpers.nix inputs) mkDarwin mkNixos mkHome;
  in {
    darwinConfigurations = mkDarwin "mba";
    nixosConfigurations =
      (mkNixos {hostname = "a3";})
      // (mkNixos {hostname = "s340";})
      // (mkNixos {
        hostname = "duet3";
        system = "aarch64-linux";
        extraModules = [(import "${inputs.mobile-nixos}/lib/configuration.nix" {device = "lenovo-wormdingler";})];
      });
    homeConfigurations =
      (mkHome {
        hostname = "deck";
        username = "deck";
        extraModules = [inputs.nix-flatpak.homeManagerModules.nix-flatpak];
      })
      // (mkHome {
        hostname = "duet3";
        system = "aarch64-linux";
      });
  };
}
