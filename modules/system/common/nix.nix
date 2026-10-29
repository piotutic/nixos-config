{ ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.extra-substituters = [ "https://cache.numtide.com" ];
  nix.settings.extra-trusted-public-keys = [
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
  ];

  nixpkgs.config.allowUnfree = true;

  # nh wraps nixos-rebuild (diff preview, nix-output-monitor) and replaces
  # nix.gc for cleanup; the two must not both be enabled.
  programs.nh = {
    enable = true;
    flake = "/home/pio/nixos-config";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };

  nix.settings.auto-optimise-store = true;
  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
    persistent = true;
    randomizedDelaySec = "45min";
  };
}
