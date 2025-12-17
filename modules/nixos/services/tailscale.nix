{...}: {
  services.tailscale.enable = true;
  networking = {
    nameservers = ["100.100.100.100" "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];
    search = ["scylla-goblin.ts.net"];
  };
}
