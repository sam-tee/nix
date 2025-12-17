{...}: {
  imports = [
    ./cosmetic
    ./home.nix
    ./packages
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
    ];
  };
}
