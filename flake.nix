{
  description = "Flake that holds all my nix stuff";
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
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    modules.url = "path:./modules";
    systems.url = "path:./systems";
    templates.url = "path:./templates";
  };
  outputs = inputs @ {self, ...}: {
    templates = inputs.templates.templates;

    darwinConfigurations = inputs.systems.darwinConfigurations;
    nixosConfigurations = inputs.systems.nixosConfigurations;
    homeConfigurations = inputs.systems.homeConfigurations;

    darwinModules = inputs.modules.darwinModules;
    homeModules = inputs.modules.homeModules;
    nixosModules = inputs.modules.nixosModules;
  };
}
