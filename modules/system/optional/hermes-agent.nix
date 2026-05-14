{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.hermes-agent.nixosModules.default
  ];

  users.users.pio.extraGroups = [ "hermes" ];

  services.hermes-agent = {
    enable = true;
    container.enable = false;

    environmentFiles = [ "/var/lib/hermes/env" ];
    addToSystemPackages = true;

    extraDependencyGroups = [ "messaging" ];

    extraPackages = with pkgs; [
      curl
      ffmpeg
      jq
      nodejs_22
      ripgrep
      tirith
    ];
  };

  environment.variables = {
    HERMES_HOME = "/var/lib/hermes/.hermes";
    HERMES_HOME_MODE = "2770";
    HERMES_SKIP_CHMOD = "1";
  };

  systemd.services.hermes-agent = {
    environment = {
      HERMES_MANAGED = lib.mkForce "";
      HERMES_HOME_MODE = "2770";
      HERMES_SKIP_CHMOD = "1";
    };

    serviceConfig.TimeoutStopSec = "210s";
  };

  system.activationScripts."hermes-agent-setup" = lib.mkForce (lib.stringAfter [ "users" ] ''
    HERMES_STATE=/var/lib/hermes
    HERMES_HOME_DIR="$HERMES_STATE/.hermes"
    PIO_HERMES=/home/pio/.hermes

    mkdir -p \
      "$HERMES_HOME_DIR" \
      "$HERMES_HOME_DIR/cron" \
      "$HERMES_HOME_DIR/sessions" \
      "$HERMES_HOME_DIR/logs" \
      "$HERMES_HOME_DIR/memories" \
      "$HERMES_HOME_DIR/plugins" \
      "$HERMES_STATE/home" \
      "$HERMES_STATE/workspace"

    if [ -f "$HERMES_STATE/env" ]; then
      install -o hermes -g hermes -m 0660 /dev/null "$HERMES_HOME_DIR/.env"
      cat "$HERMES_STATE/env" > "$HERMES_HOME_DIR/.env"
    fi

    if [ ! -f "$HERMES_HOME_DIR/config.yaml" ]; then
      install -o hermes -g hermes -m 0660 /dev/null "$HERMES_HOME_DIR/config.yaml"
      printf '{}\n' > "$HERMES_HOME_DIR/config.yaml"
    fi

    chown -R hermes:hermes "$HERMES_STATE"

    ${pkgs.acl}/bin/setfacl -Rb "$HERMES_STATE" 2>/dev/null || true

    find "$HERMES_STATE" -type d -exec chmod 2770 {} +
    find "$HERMES_STATE" -type f -perm /111 -exec chmod 0770 {} +
    find "$HERMES_STATE" -type f ! -perm /111 -exec chmod 0660 {} +

    rm -f "$HERMES_HOME_DIR/.managed"

    if [ -L "$PIO_HERMES" ]; then
      ln -sfn "$HERMES_HOME_DIR" "$PIO_HERMES"
    elif [ ! -e "$PIO_HERMES" ]; then
      ln -s "$HERMES_HOME_DIR" "$PIO_HERMES"
    else
      echo "hermes-agent: leaving existing non-symlink $PIO_HERMES untouched"
    fi

    if [ -L "$PIO_HERMES" ]; then
      chown -h pio:hermes "$PIO_HERMES"
    fi
  '');
}
