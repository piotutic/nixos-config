{ config, lib, pkgs, ... }:

let
  cfg = config.pio.docker;
in
{
  options.pio.docker = {
    startOnBoot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Start the Docker daemon automatically on boot.";
    };
  };

  config = {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      daemon.settings = {
        data-root = "/var/lib/docker";
        storage-driver = "overlay2";
        log-driver = "json-file";
        log-opts = {
          max-size = "10m";
          max-file = "3";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      docker-compose
      dive
      ctop
      lazydocker
    ];

    environment.sessionVariables = {
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
    };

    boot.kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 512;
      "net.bridge.bridge-nf-call-iptables" = 1;
      "net.bridge.bridge-nf-call-ip6tables" = 1;
      "net.ipv4.ip_forward" = 1;
    };

    networking.firewall.trustedInterfaces = [ "docker0" ];

    systemd.services.docker = lib.mkIf (!cfg.startOnBoot) {
      wantedBy = lib.mkOverride 50 [ ];
    };
  };
}
