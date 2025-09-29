{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.containerSupport;
in {
  options.containerSupport = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable container support (Docker and/or Podman).
      '';
    };

    docker = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = ''
          Whether to enable Docker.
        '';
      };

      rootless = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable Docker rootless mode.
        '';
      };
    };

    podman = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Podman as an alternative to Docker.
        '';
      };

      dockerCompat = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to provide Docker compatibility for Podman.
        '';
      };
    };

    user = mkOption {
      type = types.str;
      default = "pio";
      description = ''
        Username to add to container groups.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Docker configuration
    virtualisation.docker = mkIf cfg.docker.enable {
      enable = true;
      rootless = mkIf cfg.docker.rootless {
        enable = true;
        setSocketVariable = true;
      };

      # Optimize Docker daemon settings
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

    # Podman configuration
    virtualisation.podman = mkIf cfg.podman.enable {
      enable = true;
      dockerCompat = cfg.podman.dockerCompat;
      defaultNetwork.settings.dns_enabled = true;
    };

    # Add user to docker group (if Docker is enabled and not rootless)
    users.users.${cfg.user} = mkIf (cfg.docker.enable && !cfg.docker.rootless) {
      extraGroups = ["docker"];
    };

    # Container management tools
    environment.systemPackages = with pkgs; [
      # Core tools
      docker-compose

      # Container utilities
      dive # Docker image analyzer
      ctop # Container monitoring
      lazydocker # Terminal UI for Docker

      # Registry tools
      skopeo # Container image operations

      # Build tools
      buildah # Container image builder (works with Podman)

      # Security scanning
      trivy # Container vulnerability scanner
    ] ++ optionals cfg.podman.enable [
      podman-compose
      podman-tui
    ];

    # Enable container networking
    networking.firewall.trustedInterfaces = mkIf cfg.docker.enable ["docker0"];

    # System optimizations for containers
    boot.kernel.sysctl = {
      # Increase inotify limits for container monitoring
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 512;

      # Network optimizations for containers
      "net.bridge.bridge-nf-call-iptables" = 1;
      "net.bridge.bridge-nf-call-ip6tables" = 1;
      "net.ipv4.ip_forward" = 1;
    };

    # Note: cgroups v2 are enabled by default in modern NixOS

    # Configure systemd services for containers
    systemd.services = mkIf cfg.docker.enable {
      docker = {
        wantedBy = mkOverride 50 [];  # Don't start automatically
        serviceConfig = {
          ExecStart = mkOverride 50 "${pkgs.docker}/bin/dockerd --host=fd://";
        };
      };
    };

    # Development environment helpers
    environment.sessionVariables = mkIf cfg.docker.rootless {
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
    };

    # Warnings and info
    warnings =
      (optional (cfg.docker.enable && cfg.podman.enable)
        "Both Docker and Podman are enabled. This may cause conflicts.")
      ++ (optional (cfg.docker.enable && !cfg.docker.rootless)
        "Docker is running in rootful mode. Consider enabling rootless mode for better security.");
  };
}