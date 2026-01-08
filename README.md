# NixOS Configuration

Multi-device NixOS configuration using flakes and Home Manager. Designed for easy management across multiple machines with toggleable features per device.

## Structure

```
nixos-config/
├── flake.nix                     # Entry point with mkHost helper
├── flake.lock                    # Locked dependency versions
│
├── hosts/                        # Device configurations
│   ├── hp-laptop.nix             # Single-file host definition
│   ├── zenith.nix                # Single-file host definition
│   └── hardware/                 # Hardware configs (generated)
│       ├── hp-laptop.nix
│       └── zenith.nix
│
├── modules/
│   ├── core/                     # Always enabled on all devices
│   │   ├── default.nix           # Imports all core modules
│   │   ├── nix.nix               # Flakes, GC, store optimization
│   │   ├── boot.nix              # Bootloader config
│   │   ├── networking.nix        # NetworkManager, firewall
│   │   ├── audio.nix             # PipeWire
│   │   ├── users.nix             # User accounts, sudo
│   │   └── options.nix           # pio.* option definitions
│   │
│   └── features/                 # Toggleable per device
│       ├── default.nix           # Imports all features
│       ├── desktop.nix           # GNOME, Flatpak, multimedia
│       ├── docker.nix            # Docker rootless + tools
│       ├── mullvad.nix           # Mullvad VPN
│       ├── plymouth.nix          # Boot splash
│       ├── nvidia.nix            # NVIDIA GPU + CUDA
│       ├── gaming.nix            # Steam, Proton, GameMode
│       ├── laptop.nix            # Power management
│       └── auto-commit.nix       # Git auto-commit after rebuild
│
└── home/                         # Home Manager configurations
    ├── default.nix               # Entry point with conditional imports
    ├── common.nix                # Shared user config (shell, git, programs)
    └── packages/
        ├── base.nix              # Fonts, CLI tools (all devices)
        ├── development.nix       # Dev tools (all devices)
        └── video-editing.nix     # ffmpeg, DaVinci Resolve (optional)
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

## Available Features

Toggle features per device with `pio.features.<name>.enable`:

| Feature | Description | Options |
|---------|-------------|---------|
| `desktop` | GNOME desktop, Flatpak, multimedia, Bluetooth | - |
| `docker` | Docker rootless mode + tools (compose, dive, lazydocker) | `startOnBoot` |
| `mullvad` | Mullvad VPN with WireGuard | - |
| `plymouth` | Boot splash screen, silent boot | - |
| `nvidia` | NVIDIA proprietary drivers, 32-bit support | `cuda` (default: true) |
| `gaming` | Steam, Proton, GameMode | - |
| `laptop` | Power management, lid behavior | `lidAction`, `suspendEnabled` |
| `auto-commit` | Auto-commit config changes after rebuild | - |

Home Manager options:

| Option | Description |
|--------|-------------|
| `pio.home.videoEditing` | Include ffmpeg-full and DaVinci Resolve |

## Current Devices

| Device | Hostname | Features Enabled |
|--------|----------|------------------|
| HP 255 G | `hp-laptop` | desktop, mullvad, plymouth, laptop, auto-commit |
| Zenith Desktop | `zenith` | desktop, docker, mullvad, plymouth, nvidia, gaming, auto-commit |

## Adding a New Device

### 1. Generate hardware config (on target machine)

Boot NixOS installer or run on existing NixOS:

```bash
sudo nixos-generate-config --show-hardware-config > hardware.nix
```

### 2. Copy hardware config to repo

```bash
cp hardware.nix ~/nixos-config/hosts/hardware/mydevice.nix
```

### 3. Create host file

Create `hosts/mydevice.nix`:

```nix
# My Device - short description
{ ... }:

{
  imports = [ ./hardware/mydevice.nix ];

  pio.features = {
    desktop.enable = true;
    docker.enable = true;
    mullvad.enable = true;
    plymouth.enable = true;
    auto-commit.enable = true;
    # nvidia.enable = true;     # For NVIDIA GPUs
    # gaming.enable = true;     # For Steam/gaming
    # laptop.enable = true;     # For laptops
  };

  pio.home.videoEditing = false;
}
```

### 4. Add to flake.nix

```nix
nixosConfigurations = {
  hp-laptop = mkHost "hp-laptop";
  zenith = mkHost "zenith";
  mydevice = mkHost "mydevice";  # Add this line
};
```

### 5. Build

```bash
# First install (from NixOS installer)
sudo nixos-install --flake /path/to/nixos-config#mydevice

# Or rebuild existing system
sudo nixos-rebuild switch --flake .#mydevice
```

## Feature Details

### Desktop (`pio.features.desktop`)

- GNOME with extensions (AppIndicator, Dash-to-Dock, Vitals)
- Flatpak with Flathub
- Full GStreamer multimedia stack
- Bluetooth with enhanced settings
- AppArmor security

### Docker (`pio.features.docker`)

- Rootless mode by default
- Tools: docker-compose, dive, ctop, lazydocker
- On-demand start (set `startOnBoot = true` for servers)

### NVIDIA (`pio.features.nvidia`)

- Proprietary drivers for best performance
- 32-bit support for Steam/Wine
- CUDA toolkit and nvtop (disable with `cuda = false`)

### Laptop (`pio.features.laptop`)

- Power profiles daemon
- Configurable lid action: `"suspend"`, `"poweroff"`, `"lock"`, `"ignore"`
- Suspend disabled by default (enable with `suspendEnabled = true`)

## Maintenance

```bash
# Update all flake inputs
nix flake update

# Update specific input (e.g., claude-code)
nix flake lock --update-input claude-code

# List generations
nixos-rebuild list-generations

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Test configuration without switching
sudo nixos-rebuild test --flake .
```

## Customization

### Add packages for all devices
Edit `home/packages/base.nix` or `home/packages/development.nix`

### Add system config for all devices
Edit files in `modules/core/`

### Add a new toggleable feature
1. Create `modules/features/myfeature.nix` with `pio.features.myfeature.enable` option
2. Import it in `modules/features/default.nix`
3. Enable in host files as needed
