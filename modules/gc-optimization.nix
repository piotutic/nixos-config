{
  config,
  lib,
  pkgs,
  ...
}: {
  # Automatic garbage collection
  nix.gc = {
    automatic = true; # Enable automatic garbage collection
    dates = "weekly"; # Run weekly (can be: "daily", "weekly", "03:15", etc.)
    options = "--delete-older-than 30d"; # Delete generations older than 30 days
    persistent = true; # Run on next boot if system was off during scheduled time
    randomizedDelaySec = "45min"; # Random delay to spread load (useful for multiple systems)
  };

  # Store optimization - deduplicates identical files using hard links
  # Can save 25-35% of store space
  nix.settings.auto-optimise-store = true; # Optimize files as they're added to store

  nix.optimise = {
    automatic = true; # Run scheduled optimization service
    dates = ["03:45"]; # Run at 3:45 AM (systemd.time format)
    persistent = true; # Run on next boot if missed
    randomizedDelaySec = "45min"; # Random delay before running
  };

  # Limit boot loader entries to prevent accumulation
  boot.loader.systemd-boot.configurationLimit = 5; # Keep max 5 generations in boot menu
}
