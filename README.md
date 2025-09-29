# NixOS Configuration - Pio

Modern NixOS configuration using flakes with Home Manager integration, modular architecture, and pragmatic hardware configuration management.

## Quick Start

```bash
# Rebuild system
sudo nixos-rebuild switch --impure --flake .#pio

# Update and rebuild
nix flake update && sudo nixos-rebuild switch --impure --flake .#pio

# Use aliases (configured in zsh)
update    # rebuild system
upgrade   # update + rebuild
nix-gc    # "sudo nix-collect-garbage -d"
nix-dev   # "nix develop --profile .nix-profile/.nix-profile"
```

## Structure

```
├── configuration.nix           # Main NixOS config
├── flake.nix                  # Flake definition & inputs
├── home.nix                   # Home Manager config
├── modules/                   # Modular configurations
│   ├── system/               # Core system configuration
│   │   ├── disable-suspend.nix    # Suspend/hibernate management
│   │   └── gc-optimization.nix    # Garbage collection & store optimization
│   ├── hardware/             # Hardware-specific configuration
│   │   └── nvidia.nix             # Auto-detecting NVIDIA drivers
│   ├── desktop/              # Desktop environment & GUI
│   │   └── desktop.nix            # GNOME with extensions & multimedia
│   └── development/          # Development tools & shell environment
│       ├── zsh.nix                # Modern shell with aliases
│       ├── starship.nix           # Customized prompt
│       ├── kitty.nix              # Terminal emulator
│       └── containers.nix         # Docker/Podman support
└── docs/                      # Documentation
    ├── system-management.md   # Rebuild, GC, generations
    └── modules/              # Per-module documentation
```

## Features

- **🔄 Auto-hardware detection**: NVIDIA drivers only when GPU present
- **📦 Modular architecture**: Clean separation by function (system/hardware/desktop/development)
- **🏠 Home Manager**: Declarative user environment with enhanced Git config
- **🐳 Container support**: Docker/Podman with rootless mode and dev tools
- **🖥️ Desktop environment**: GNOME with extensions, multimedia, and productivity tools
- **⚡ Modern tools**: zsh, starship, kitty, fd, ripgrep, delta, direnv
- **♻️ System optimization**: Automatic garbage collection and performance tuning
- **📚 Well documented**: Comprehensive docs in `docs/`

## Documentation

See [`docs/`](docs/) for detailed documentation:

- [System Management](docs/system-management.md) - Rebuilds, rollbacks, garbage collection
- [NVIDIA Module](docs/modules/nvidia.md) - GPU driver configuration

## Hardware Configuration Strategy

This configuration uses a **pragmatic approach** to hardware management that prioritizes convenience and multi-machine deployment over flake purity.

### Why `--impure`?

We import `/etc/nixos/hardware-configuration.nix` directly rather than copying hardware configs into the repository:

```nix
imports = [
  /etc/nixos/hardware-configuration.nix  # Machine-local hardware config
  ./modules/system/disable-suspend.nix
  # ... other modules
];
```

**Benefits of this approach:**
- **One codebase, multiple machines**: Same config deploys to any hardware without modification
- **No cross-contamination**: Each machine reads its own hardware-specific UUIDs, kernel modules, etc.
- **No repo bloat**: Hardware configs stay local where they belong
- **Simple deployment**: Just `git clone` and rebuild on any new machine

**Alternative approaches and their problems:**
- **Build-time copying**: Hardware config gets committed, causes UUID conflicts across machines
- **Per-machine branches**: Requires maintaining separate branches for each device
- **Host-specific configs**: Repo becomes cluttered with device-specific files

### Hardware Support

- **RTX 4060**: Automatically detected and configured
- **Non-NVIDIA systems**: Drivers skipped, no conflicts
- **Any hardware**: Config adapts to local `/etc/nixos/hardware-configuration.nix`
- **Multi-machine**: Same repository works on desktop, laptop, server, etc.

## Notes

- Uses `--impure` flag by design for hardware config flexibility
- Package versions pinned via `flake.lock` for reproducibility
- Home Manager integrated into NixOS rebuild process
- Hardware configs remain machine-local and git-untracked
