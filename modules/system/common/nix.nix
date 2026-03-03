{ ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
    persistent = true;
    randomizedDelaySec = "45min";
  };

  nix.settings.auto-optimise-store = true;
  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
    persistent = true;
    randomizedDelaySec = "45min";
  };
}
