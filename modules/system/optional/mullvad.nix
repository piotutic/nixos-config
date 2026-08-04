{ ... }:

{
  services.mullvad-vpn.enable = true;
  # `pkgs.mullvad-vpn` is now GUI-only; the daemon lives in `pkgs.mullvad`,
  # which is the default for `services.mullvad-vpn.package`.
  services.mullvad-vpn.gui.enable = true;

  networking.wireguard.enable = true;
  networking.firewall.enable = true;
}
