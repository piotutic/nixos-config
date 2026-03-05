{ ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.extra-substituters = [ "https://cache.numtide.com" ];
  nix.settings.extra-trusted-public-keys = [
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
  ];

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
