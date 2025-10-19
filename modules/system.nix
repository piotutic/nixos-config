{
  config,
  lib,
  pkgs,
  ...
}: {
  # Disable suspend/hibernate
  systemd.targets."suspend".enable = false;
  systemd.targets."hibernate".enable = false;
  systemd.targets."hybrid-sleep".enable = false;

  services.logind.settings.Login = {
    HandleSuspendKey = "ignore";
    HandleLidSwitch = "poweroff";
    HandleLidSwitchDocked = "ignore";
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
    persistent = true;
    randomizedDelaySec = "45min";
  };

  # Store optimization
  nix.settings.auto-optimise-store = true;
  nix.optimise = {
    automatic = true;
    dates = ["03:45"];
    persistent = true;
    randomizedDelaySec = "45min";
  };

  # Limit boot loader entries
  boot.loader.systemd-boot.configurationLimit = 5;
}
