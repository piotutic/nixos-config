# Auto-commit script for NixOS configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.pio.features.auto-commit;

  nixos-auto-commit = pkgs.writeShellScriptBin "nixos-auto-commit" ''
    #!/usr/bin/env bash
    # Auto-commit script for NixOS configuration changes
    # Runs after successful nixos-rebuild to track config history

    set -e

    CONFIG_DIR="/home/pio/nixos-config"
    cd "$CONFIG_DIR"

    # Check if there are any changes
    if [[ -z $(${pkgs.git}/bin/git status --porcelain) ]]; then
        echo "No config changes to commit"
        exit 0
    fi

    # Stage all changes
    ${pkgs.git}/bin/git add -A

    # Create commit with timestamp
    TIMESTAMP=$(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S')
    ${pkgs.git}/bin/git commit -m "config: $TIMESTAMP"

    echo "Config changes committed: $TIMESTAMP"
  '';
in {
  options.pio.features.auto-commit = {
    enable = lib.mkEnableOption "NixOS config auto-commit script";
  };

  config = lib.mkIf cfg.enable {
    # Install auto-commit script to system
    environment.systemPackages = [
      nixos-auto-commit
    ];
  };
}
