{ ... }:

{
  # Log in once after the first switch with `sudo tailscale up`. No auth key
  # here: the node key lives in /var/lib/tailscale, never in the store.
  services.tailscale = {
    enable = true;
    # UDP 41641 for direct (non-relayed) connections.
    openFirewall = true;
  };

  # Hermes dashboard for Hermes Conduit (home/optional/hermes-agent.nix).
  # Reachable from the tailnet only: the port is open on tailscale0 and
  # nowhere else, and tailscale0 is deliberately not a trusted interface.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 9119 ];
}
