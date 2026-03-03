{ pkgs, ... }:

let
  nixos-auto-commit = pkgs.writeShellScriptBin "nixos-auto-commit" ''
    #!/usr/bin/env bash
    # Auto-commit config changes after a successful rebuild.

    set -e

    CONFIG_DIR="/home/pio/nixos-config"
    cd "$CONFIG_DIR"

    if [[ -z $(${pkgs.git}/bin/git status --porcelain) ]]; then
        echo "No config changes to commit"
        exit 0
    fi

    ${pkgs.git}/bin/git add -A

    TIMESTAMP=$(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S')
    ${pkgs.git}/bin/git commit -m "config: $TIMESTAMP"

    echo "Config changes committed: $TIMESTAMP"
  '';
in
{
  environment.systemPackages = [
    nixos-auto-commit
  ];
}
