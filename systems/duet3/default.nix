{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username}.imports = [./home.nix];
  hardware.firmware = [
    pkgs.chromeos-sc7180-unredistributable-firmware
  ];
  hardware.sensor.iio.enable = false;

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  services.tailscale = {
    enable = true;
  };

  nMods = {
    de.environment = "plasma";
    boot.enable = false;
    ssh.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHK6sBwLbi0FkwXzzZO7Mbd6ha66KX+zSOJgGUWiTYzL duet3";
  };
}
