inputs: let
  mkArgs = hostname: username: {
    inherit hostname username inputs;
  };
in {
  mkDarwin = hostname: {
    ${hostname} = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = mkArgs hostname "sam";
      modules = [
        inputs.akhlus.darwinModules.default
        ./${hostname}
      ];
    };
  };
  mkNixos = {
    hostname,
    system ? "x86_64-linux",
    username ? "sam",
    extraModules ? [],
  }: {
    ${hostname} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = mkArgs hostname username;
      modules =
        [
          inputs.akhlus.nixosModules.default
          ./${hostname}
        ]
        ++ extraModules;
    };
  };
  mkHome = {
    hostname,
    system ? "x86_64-linux",
    username ? "sam",
    extraModules ? [],
  }: {
    ${hostname} = inputs.home.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = mkArgs hostname username;
      modules =
        [
          inputs.akhlus.homeModules.all
          ./${hostname}/home.nix
        ]
        ++ extraModules;
    };
  };
}
