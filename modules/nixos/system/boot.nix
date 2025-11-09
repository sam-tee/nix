{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nMods.boot;
in {
  options.nMods.boot = {
    enable = lib.mkEnableOption "Boot Options" // {default = true;};
    loader = lib.mkOption {
      type = lib.types.enum ["systemd" "grub"];
      description = "Which bootloader to use in the config";
      default = "systemd";
    };
    grubDevice = lib.mkOption {
      type = lib.types.str;
      description = "Device that has GRUB loader on it";
    };
    emulatedSystems = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["aarch64-linux"];
      description = "List of systems to emulate";
    };
    enablePlymouth = lib.mkEnableOption "Enable Plymouth" // {default = true;};
    plymouthTheme = lib.mkOption {
      type = lib.types.str;
      default = "bgrt";
      description = "Theme name for plymouth";
    };
  };
  config = lib.mkIf cfg.enable {
    boot = {
      binfmt.emulatedSystems = cfg.emulatedSystems;
      consoleLogLevel = 0;
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
      initrd = {
        enable = true;
        systemd.enable = cfg.loader == "systemd";
        verbose = false;
      };
      kernelModules = ["v4l2loopback"];
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = [
        "splash"
        "quiet"
        "boot.shell_on_fail"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
      loader = {
        systemd-boot = lib.mkIf (cfg.loader == "systemd") {
          enable = cfg.loader == "systemd";
          configurationLimit = 5;
        };
        grub = lib.mkIf (cfg.loader == "grub") {
          enable = cfg.loader == "grub";
          device = cfg.grubDevice;
          useOSProber = cfg.loader == "grub";
          configurationLimit = 5;
        };
        efi.canTouchEfiVariables = true;
        timeout = 1;
      };
      plymouth = {
        enable = cfg.enablePlymouth;
        theme = cfg.plymouthTheme;
      };
    };
  };
}
