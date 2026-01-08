# Mullvad VPN
{ config, lib, pkgs, ... }:

let
  cfg = config.pio.features.mullvad;
in {
  options.pio.features.mullvad = {
    enable = lib.mkEnableOption "Mullvad VPN";
  };

  config = lib.mkIf cfg.enable {
    # Enable Mullvad VPN service
    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad-vpn;

    # Install Mullvad GUI application
    environment.systemPackages = with pkgs; [
      mullvad-vpn
    ];

    # Enable WireGuard support
    networking.wireguard.enable = true;

    # Basic firewall - Mullvad handles the kill switch via lockdown mode
    # To enable kill switch, run: mullvad lockdown-mode set on
    networking.firewall.enable = true;

    # Enable Mullvad daemon to start on boot
    systemd.services.mullvad-daemon = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
    };
  };
}
