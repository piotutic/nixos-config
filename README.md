# NixOS Configuration

Multi-device NixOS configuration using flakes and Home Manager. Designed for easy management across multiple machines with shared and device-specific configurations.

## Structure

```
nixos-config/
├── flake.nix                 # Main entry point with mkHost helper
├── flake.lock                # Locked dependency versions
│
├── hosts/                    # Per-device configurations
│   ├── common/
│   │   └── default.nix       # Shared system config (all devices)
│   └── hp-laptop/
│       ├── default.nix       # HP-specific config & module imports
│       └── hardware.nix      # Hardware config (from nixos-generate-config)
│
├── home/                     # Home Manager configurations
│   ├── common.nix            # Shared user config (shell, git, programs)
│   └── packages/
│       ├── base.nix          # Fonts, CLI tools (all devices)
│       ├── development.nix   # Dev tools (all devices)
│       └── video-editing.nix # Heavy media packages (powerful devices only)
│
└── modules/                  # System feature modules
    ├── system.nix            # GC, store optimization
    ├── desktop.nix           # GNOME, Flatpak, multimedia
    ├── containers.nix        # Docker rootless
    ├── mullvad.nix           # VPN
    ├── auto-commit.nix       # Git auto-commit after rebuild
    └── plymouth.nix          # Boot splash
```

## Quick Start

```bash
# Rebuild system (auto-detects hostname)
update

# Update flake inputs and rebuild
upgrade

# Clean old generations
nix-gc
```

Or manually:
```bash
sudo nixos-rebuild switch --flake /home/pio/nixos-config
```

## Adding a New Device

### 1. On the new device, install NixOS and enable flakes

Add to your initial `/etc/nixos/configuration.nix`:
```nix
{
  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = [ pkgs.git ];
}
```

Rebuild: `sudo nixos-rebuild switch`

### 2. Clone this repo

```bash
git clone https://github.com/piotutic/nixos-config ~/nixos-config
cd ~/nixos-config
```

### 3. Create device configuration

```bash
# Create device directory
mkdir -p hosts/NEW-DEVICE

# Generate hardware config
nixos-generate-config --show-hardware-config > hosts/NEW-DEVICE/hardware.nix
```

Create `hosts/NEW-DEVICE/default.nix`:
```nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/system.nix
    ../../modules/desktop.nix
    ../../modules/containers.nix    # optional
    ../../modules/mullvad.nix       # optional
    ../../modules/auto-commit.nix
    ../../modules/plymouth.nix
  ];

  # Device-specific settings
  services.power-profiles-daemon.enable = true;  # for laptops
}
```

### 4. Add to flake.nix

```nix
nixosConfigurations = {
  # Existing devices...

  NEW-DEVICE = mkHost {
    hostname = "NEW-DEVICE";
    enableVideoEditing = false;  # true for powerful machines
  };
};
```

### 5. Build

```bash
sudo nixos-rebuild switch --flake .#NEW-DEVICE
```

After first rebuild, the hostname is set and `update` works automatically.

## Configuration Options

### mkHost Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `hostname` | required | Device hostname and config directory name |
| `enableVideoEditing` | `false` | Include ffmpeg-full and davinci-resolve |

### Package Profiles

| Profile | Packages | Used By |
|---------|----------|---------|
| `base.nix` | Fonts, btop, eza, bat, fd, ripgrep, alejandra | All devices |
| `development.nix` | wget, curl, just, tmux, jq, vscode, gnumake, claude-code | All devices |
| `video-editing.nix` | ffmpeg-full, davinci-resolve | Powerful devices only |

## Current Devices

| Device | Hostname | Video Editing | Description |
|--------|----------|---------------|-------------|
| HP 255 G | `hp-laptop` | No | Weak laptop, power-optimized |

## Features

### System
- **Pure flake builds** - No `--impure` flag needed
- **GNOME Desktop** - Clean desktop with extensions
- **Automatic GC** - Weekly cleanup, keep last 30 days
- **Store optimization** - Automatic deduplication
- **systemd-boot** - Keep last 5 generations

### Development
- **Docker** - Rootless mode, on-demand start
- **Modern shell** - zsh + starship + syntax highlighting
- **Better CLI** - eza, bat, fd, ripgrep, delta
- **Git** - Extensive aliases, delta diff, gh CLI
- **VS Code FHS** - Better extension compatibility

### Per-Device Flexibility
- Hardware configs tracked in git per-device
- Optional modules (containers, VPN, video editing)
- Power management for laptops vs desktops

## Maintenance

```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# List generations
nixos-rebuild list-generations

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Boot into previous generation
# Select at boot menu (systemd-boot)
```

## Customization

### Add packages for all devices

Edit `home/packages/base.nix` or `home/packages/development.nix`

### Add packages for specific device

Create a new package file and import conditionally, or add directly to the device's home-manager config in `flake.nix`

### Add system-level config for all devices

Edit `hosts/common/default.nix`

### Add system-level config for one device

Edit `hosts/DEVICE/default.nix`
