{ pkgs, ... }:

{
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  environment.systemPackages = with pkgs; [
    mullvad-vpn
  ];

  networking.wireguard.enable = true;
  networking.firewall.enable = true;

  systemd.services.mullvad-daemon = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
  };
}
