{ ... }:

{
  # Key-only SSH. Port 22 is open on tailscale0, plus to one LAN host (the
  # Mac, which is not on the tailnet); closed everywhere else.
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.pio.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzHMvQqhbso3fi5GsRsH5RIehzkaoy+iQ2ytplRQsOe voxel-game-mac"
  ];

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

  # iptables backend (networking.nftables is off). nixos-fw is flushed and
  # rebuilt on every firewall start, so the stop command is just tidiness.
  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p tcp -s 10.0.0.250 --dport 22 -j nixos-fw-accept
  '';
  networking.firewall.extraStopCommands = ''
    iptables -D nixos-fw -p tcp -s 10.0.0.250 --dport 22 -j nixos-fw-accept 2>/dev/null || true
  '';
}
