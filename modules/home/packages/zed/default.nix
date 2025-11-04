{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hMods.packages.zed;
  akhlusTheme = (import ./theme.nix {inherit config lib;}).themeOut;
in {
  options.hMods.packages.zed = {
    enable = lib.mkEnableOption "Zed" // {default = config.hMods.packages.enableMinimal;};
    package = lib.mkPackageOption pkgs "zed-editor" {
      nullable = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = cfg.enable;
      extraPackages = [pkgs.nixd];
      installRemoteServer = true;
      package = cfg.package;
      userSettings = builtins.fromJSON (builtins.readFile ./zed-settings.json);
      themes = {akhlus = akhlusTheme;};
    };
  };
}
