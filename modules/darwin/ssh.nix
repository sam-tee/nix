{
  config,
  lib,
  username,
  ...
}: let
  cfg = config.dMods.ssh;
in {
  options.dMods.ssh = {
    enable = lib.mkEnableOption "ssh config management" // {default = true;};
    sshAuthSock = lib.mkOption {
      type = lib.types.str;
      description = "Value to set env variable SSH_AUTH_SOCK";
      default = "/Users/${username}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock";
    };
    publicKey = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Public key of the machine";
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      description = "Extra config to write to the sshd_config file";
      default = ''
        AddressFamily any
        PermitRootLogin no
        UsePAM yes
        AcceptEnv LANG LC_* TERM EDITOR
        Include /etc/ssh/crypto.conf
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    environment.variables = {
      SSH_AUTH_SOCK = cfg.sshAuthSock;
    };
    users.users.${username}.openssh.authorizedKeys.keys = [cfg.publicKey];
    services.openssh = {
      enable = true;
      extraConfig = cfg.extraConfig;
    };
  };
}
