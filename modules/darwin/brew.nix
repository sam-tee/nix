{
  config,
  lib,
  username,
  ...
}: let
  cfg = config.dMods.homebrew;
in {
  options.dMods.homebrew = {
    enable = lib.mkEnableOption "homebrew" // {default = true;};
    extraCasks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "casks other than ghostty to install";
    };
    extraMasApps = lib.mkOption {
      type = lib.types.attrsOf lib.types.ints.positive;
      default = {};
      description = "mas apps other than bitwarden to install";
    };
  };
  config = lib.mkIf cfg.enable {
    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = username;
      autoMigrate = true;
    };

    homebrew = {
      enable = true;
      casks = ["ghostty" "spotify"] ++ cfg.extraCasks;
      masApps = {"Bitwarden" = 1352778147;} // cfg.extraMasApps;
      onActivation.cleanup = "zap";
    };
  };
}
