{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.aspects.ssh;
in {
  options.aspects.ssh = {
    enable = lib.mkEnableOption "SSH aspect";

    server = {
      enable = lib.mkEnableOption "Enable SSH server";
      port = lib.mkOption {
        type = lib.types.port;
        default = 2222;
        description = "SSH server port.";
      };
      publicKey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Public key to authorize for the user.";
      };
      passwordAuth = lib.mkEnableOption "Allow password authentication" // {default = false;};
      rootLogin = lib.mkEnableOption "Allow root login" // {default = false;};
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = ''
          AcceptEnv LANG LC_* TERM EDITOR
        '';
        description = "Extra configuration for sshd.";
      };
    };

    fail2ban = {
      enable = lib.mkEnableOption "Enable fail2ban for SSH" // {default = true;};
    };

    agent = {
      enable = lib.mkEnableOption "Configure SSH agent socket";
      socket = lib.mkOption {
        type = lib.types.str;
        description = "Path to the SSH agent socket.";
        default =
          if pkgs.stdenv.isDarwin
          then "/Users/${username}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
          else "/home/${username}/.bitwarden-ssh-agent.sock";
      };
    };

    client = {
      enable = lib.mkEnableOption "Configure SSH client";
      enableDefaultConfig = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = ''
          SendEnv EDITOR TERM LANG LC_*
        '';
      };
      matchBlocks = lib.mkOption {
        type = with lib.types;
          attrsOf (submodule {
            options = {
              hostname = lib.mkOption {type = str;};
              user = lib.mkOption {type = str;};
              port = lib.mkOption {type = port;};
              identityFile = lib.mkOption {type = str;};
            };
          });
        default = {
          "u410" = {
            hostname = "u410";
            user = "u410";
            port = 2222;
            identityFile = "~/.ssh/pubKeys/u410.pub";
          };
          "a3" = {
            hostname = "a3";
            user = "sam";
            port = 2222;
            identityFile = "~/.ssh/pubKeys/a3.pub";
          };
          "duet3" = {
            hostname = "duet3";
            user = "sam";
            port = 2222;
            identityFile = "~/.ssh/pubKeys/duet3.pub";
          };
          "mba" = {
            hostname = "mba";
            user = "sam";
            port = 22;
            identityFile = "~/.ssh/pubKeys/mba.pub";
          };
          "*" = {};
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # SSH Agent
    (lib.mkIf cfg.agent.enable {
      environment.variables.SSH_AUTH_SOCK = cfg.agent.socket;
    })

    # SSH Server
    (lib.mkIf cfg.server.enable (lib.mkMerge [
      {
        users.users.${username}.openssh.authorizedKeys.keys = lib.mkIf (cfg.server.publicKey != "") [cfg.server.publicKey];
      }

      # NixOS specific server config
      (lib.mkIf pkgs.stdenv.isLinux {
        services.openssh = {
          enable = true;
          ports = [cfg.server.port];
          settings = {
            PasswordAuthentication = cfg.server.passwordAuth;
            PermitRootLogin =
              if cfg.server.rootLogin
              then "yes"
              else "no";
          };
          extraConfig = cfg.server.extraConfig;
        };
        services.fail2ban.enable = cfg.fail2ban.enable;
      })

      # Darwin specific server config
      (lib.mkIf pkgs.stdenv.isDarwin {
        services.openssh = {
          enable = true;
          extraConfig = ''
            Port ${toString cfg.server.port}
            PasswordAuthentication ${
              if cfg.server.passwordAuth
              then "yes"
              else "no"
            }
            PermitRootLogin ${
              if cfg.server.rootLogin
              then "yes"
              else "no"
            }
            UsePAM yes
            Include /etc/ssh/crypto.conf
            ${cfg.server.extraConfig}
          '';
        };
      })
    ]))

    # SSH Client (home-manager)
    (lib.mkIf cfg.client.enable {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = cfg.client.enableDefaultConfig;
        matchBlocks = cfg.client.matchBlocks;
        extraConfig = cfg.client.extraConfig;
      };
    })
  ]);
}
