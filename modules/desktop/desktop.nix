{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop;
in {
  options.desktop = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable desktop environment enhancements.
      '';
    };

    gnome = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable GNOME desktop environment.
        '';
      };

      extensions = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install useful GNOME extensions.
        '';
      };

      excludePackages = mkOption {
        type = types.listOf types.package;
        default = with pkgs; [
          totem          # Video player (we have VLC)
          epiphany       # Web browser (we have Brave)
          geary          # Email client
          gnome-music    # Music player
          gnome-photos   # Photo viewer
          simple-scan    # Scanner utility (if not needed)
          yelp           # Help viewer
        ];
        description = ''
          GNOME packages to exclude from installation.
        '';
      };
    };

    multimedia = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable enhanced multimedia support.
        '';
      };
    };

    productivity = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable productivity tools and utilities.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # GNOME desktop environment
    services.xserver = mkIf cfg.gnome.enable {
      enable = true;
      xkb.layout = "us";
    };

    # Display manager (updated path)
    services.displayManager.gdm.enable = mkIf cfg.gnome.enable true;

    # Desktop manager (updated path)
    services.desktopManager.gnome.enable = mkIf cfg.gnome.enable true;

    # Exclude unwanted GNOME packages
    environment.gnome.excludePackages = mkIf cfg.gnome.enable cfg.gnome.excludePackages;

    # GNOME extensions and utilities
    environment.systemPackages = with pkgs; mkMerge [
      # Core desktop utilities
      [
        gnome-tweaks
        dconf-editor
        gparted           # Disk partitioning
        baobab           # Disk usage analyzer
        file-roller      # Archive manager
      ]

      # GNOME extensions (if enabled)
      (mkIf cfg.gnome.extensions [
        gnomeExtensions.appindicator
        gnomeExtensions.dash-to-dock
        gnomeExtensions.user-themes
        gnomeExtensions.clipboard-indicator
        gnomeExtensions.system-monitor
        gnomeExtensions.workspace-indicator
        gnomeExtensions.caffeine
        gnomeExtensions.blur-my-shell
        gnomeExtensions.vitals
      ])

      # Multimedia support (if enabled)
      (mkIf cfg.multimedia.enable [
        # Audio/Video codecs
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav
        gst_all_1.gst-vaapi

        # Media tools
        playerctl        # Media player control
        pavucontrol      # PulseAudio volume control
        easyeffects      # Audio effects

        # Image viewers/editors
        loupe           # GNOME image viewer
        gimp            # Image editor

        # Video tools (already have obs-studio, vlc, ffmpeg-full)
      ])

      # Productivity tools (if enabled)
      (mkIf cfg.productivity.enable [
        # System monitoring
        gnome-system-monitor
        htop
        iotop

        # File management
        nautilus-python  # Nautilus extensions support

        # Screenshots and screen recording (already have obs-studio)
        gnome-screenshot

        # Document viewers
        evince          # PDF viewer

        # Archive support
        unzip
        zip
        p7zip
        unrar

        # System tools
        tree
        ncdu            # Disk usage analyzer (CLI)
        lsof            # List open files
        strace          # System call tracer
      ])
    ];

    # Enhanced fonts
    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        source-code-pro
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
      ];

      fontconfig = {
        defaultFonts = {
          serif = [ "Noto Serif" "Liberation Serif" ];
          sansSerif = [ "Noto Sans" "Liberation Sans" ];
          monospace = [ "JetBrainsMono Nerd Font" "Fira Code" "Liberation Mono" ];
        };
      };
    };

    # Flatpak support for additional desktop applications
    services.flatpak.enable = true;

    # XDG portal for better desktop integration
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    # Thumbnail generation
    services.tumbler.enable = true;

    # Location services (for automatic timezone, night light, etc.)
    services.geoclue2.enable = true;

    # Better hardware support
    hardware = {
      # Enable all firmware
      enableAllFirmware = true;

      # Bluetooth support
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            ControllerMode = "dual";
            FastConnectable = "true";
            Experimental = "true";
          };
        };
      };
    };

    # Services for better desktop experience
    services = {
      # Bluetooth GUI
      blueman.enable = mkIf config.hardware.bluetooth.enable true;

      # GVfs for better file manager integration
      gvfs.enable = true;

      # UDP discovery for network services
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      # Power management
      power-profiles-daemon.enable = true;

      # Automatic device mounting
      udisks2.enable = true;
    };

    # Security enhancements
    security = {
      # Allow software to ask for passwords via GUI
      polkit.enable = true;

      # Better AppArmor support
      apparmor = {
        enable = true;
        killUnconfinedConfinables = true;
      };
    };

    # Performance optimizations for desktop
    boot.kernel.sysctl = {
      # Improve desktop responsiveness
      "vm.swappiness" = 10;
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;

      # Network optimizations
      "net.core.default_qdisc" = "cake";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    # Automatic login for single-user systems (commented out for security)
    # services.displayManager.autoLogin = {
    #   enable = true;
    #   user = "pio";
    # };

    # Better session management
    services.displayManager.defaultSession = "gnome";
  };
}