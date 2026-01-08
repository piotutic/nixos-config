# Docker container support
{ config, lib, pkgs, ... }:

let
  cfg = config.pio.features.docker;
in {
  options.pio.features.docker = {
    enable = lib.mkEnableOption "Docker container support";

    startOnBoot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Start Docker daemon automatically on boot";
    };
  };

  config = lib.mkIf cfg.enable {
    # Docker with rootless mode
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

    # Container tools
    environment.systemPackages = with pkgs; [
      docker-compose
      dive # Docker image analyzer
      ctop # Container monitoring
      lazydocker # Terminal UI for Docker
    ];

    # Environment variable for rootless Docker
    environment.sessionVariables = {
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
    };

    # System optimizations for containers
    boot.kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 512;
      "net.bridge.bridge-nf-call-iptables" = 1;
      "net.bridge.bridge-nf-call-ip6tables" = 1;
      "net.ipv4.ip_forward" = 1;
    };

    networking.firewall.trustedInterfaces = [ "docker0" ];

    # Don't start Docker automatically unless requested
    systemd.services.docker = lib.mkIf (!cfg.startOnBoot) {
      wantedBy = lib.mkOverride 50 [ ];
    };
  };
}
