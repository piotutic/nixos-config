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
    FILES=$(${pkgs.git}/bin/git diff --cached --name-only)
    COUNT=$(echo "$FILES" | ${pkgs.coreutils}/bin/wc -l)
    SUMMARY=$(echo "$FILES" | ${pkgs.coreutils}/bin/head -n 3 | ${pkgs.coreutils}/bin/paste -sd, - | ${pkgs.gnused}/bin/sed 's/,/, /g')
    if [[ $COUNT -gt 3 ]]; then
        SUMMARY="$SUMMARY (+$((COUNT - 3)) more)"
    fi
    ${pkgs.git}/bin/git commit -m "config: $SUMMARY" -m "$TIMESTAMP" -m "$FILES"

    echo "Config changes committed: $TIMESTAMP"
  '';
in
{
  environment.systemPackages = [
    nixos-auto-commit
  ];
}
