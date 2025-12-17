{
  inputs,
  self,
  ...
}: let
  args = {
    hostname = "test";
    username = "sam";
    inherit inputs;
  };
in {
  darwinConfigurations."test" = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = args;
    modules = [self.darwinModules.default];
  };
  nixosConfigurations."test" = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = args;
    modules = [self.nixosModules.default];
  };
  homeConfigurations."test" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
    extraSpecialArgs = args;
    modules = [self.nixosModules.all];
  };
}
