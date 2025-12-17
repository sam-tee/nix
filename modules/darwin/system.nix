{
  hostname,
  pkgs,
  username,
  ...
}: {
  networking.hostName = hostname;
  security.pam.services.sudo_local.touchIdAuth = true;
  services.tailscale.enable = true;
  system = {
    stateVersion = 6;
    primaryUser = "${username}";
    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        PMPrintingExpandedStateForPrint = true;
        _HIHideMenuBar = true;
        "com.apple.trackpad.forceClick" = false;
      };
      WindowManager = {
        AppWindowGroupingBehavior = false;
        AutoHide = true;
        EnableStandardClickToShowDesktop = false;
        EnableTiledWindowMargins = false;
        EnableTilingByEdgeDrag = true;
        GloballyEnabled = false;
        HideDesktop = true;
        StageManagerHideWidgets = true;
        StandardHideDesktopIcons = true;
        StandardHideWidgets = true;
      };
      controlcenter = {
        BatteryShowPercentage = true;
        Sound = false;
        NowPlaying = true;
      };
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        expose-animation-duration = 0.0;
        largesize = 16;
        launchanim = false;
        magnification = false;
        mineffect = "scale";
        minimize-to-application = true;
        persistent-apps = [
          {app = "${pkgs.brave}/Applications/Brave Browser.app";}
          {app = "${pkgs.zed-editor}/Applications/Zed.app";}
          {app = "/Applications/Ghostty.app";}
          {app = "/Applications/Spotify.app";}
        ];
        show-process-indicators = true;
        show-recents = false;
        showhidden = true;
        tilesize = 34;
      };
      finder = {
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXPreferredViewStyle = "Nlsv";
        NewWindowTarget = "Home";
        QuitMenuItem = true;
        ShowExternalHardDrivesOnDesktop = false;
        ShowHardDrivesOnDesktop = false;
        ShowPathbar = true;
        ShowRemovableMediaOnDesktop = false;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
