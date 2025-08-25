# NixOS config (flake) – Pio

This repo contains my NixOS system configuration using flakes and Home Manager.
Hardware is read from `/etc/nixos/hardware-configuration.nix`, so rebuilds use `--impure`.

## Quick start

- Rebuild and switch:
```bash
sudo nixos-rebuild switch --impure --flake /home/pio/nixos-config#pio
```

- Update inputs (nixpkgs, HM), then rebuild:
```bash
nix flake update /home/pio/nixos-config
sudo nixos-rebuild switch --impure --flake /home/pio/nixos-config#pio
```

- Roll back to previous system generation (via boot menu or immediately):
```bash
# Immediate rollback to previous generation
sudo nixos-rebuild switch --rollback
```

## System generations (list / diff / delete)

- List system generations:
```bash
sudo nix profile history --profile /nix/var/nix/profiles/system
# or (legacy)
sudo nix-env -p /nix/var/nix/profiles/system --list-generations
```

- Diff current system vs a generation:
```bash
# Replace GEN with a number from history
sudo nix store diff-closures /nix/var/nix/profiles/system-*-link /nix/var/nix/profiles/system-*-link
# Practical helper (current vs previous):
sudo nix store diff-closures $(readlink -f /nix/var/nix/profiles/system) $(ls -d /nix/var/nix/profiles/system-*-link | tail -n2 | head -n1)
```

- Delete older system generations safely:
```bash
# Keep recent ones by age
a) delete by age (recommended)
sudo nix-collect-garbage --delete-older-than 7d

# Or wipe history by age with the new CLI
b) delete by age (new CLI)
sudo nix profile wipe-history --older-than 30d --profile /nix/var/nix/profiles/system

# Or delete specific generations (legacy)
c) delete by generation ids
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations 10 11 12
```

Note: Do not delete the current/booted generation.

## User environment generations (list / delete)

If you use `nix profile` (default on flakes):
```bash
# List user profile history
nix profile history

# Delete old user generations by age
nix profile wipe-history --older-than 30d
```

If you still use legacy `nix-env` user profile:
```bash
# List
nix-env --list-generations
# Delete specific generations
nix-env --delete-generations 45 46
```

## Home Manager generations (optional)

When the `home-manager` CLI is available:
```bash
# List HM generations
home-manager generations
# Expire older HM generations by age (keeps recent ones)
home-manager expire-generations "30 days ago"
# Switch to this repo’s HM config only (usually not needed if using nixos-rebuild)
home-manager switch --flake /home/pio/nixos-config#pio
```

## Garbage collection (system and user)

- Collect unreachable store paths for the current user:
```bash
nix-collect-garbage
```

- Collect unreachable store paths for the whole system:
```bash
sudo nix-collect-garbage
```

- Aggressive GC (also deletes old generations first):
```bash
# User
nix-collect-garbage -d
# System
sudo nix-collect-garbage -d
```

- Verify store size and roots:
```bash
# Show store size
sudo du -sh /nix/store
# Find roots holding items alive
sudo nix-store --gc --print-roots
```

## Helper aliases (optional)

Add to your shell rc (e.g. `~/.bashrc`):
```bash
alias ns='sudo nixos-rebuild switch --impure --flake /home/pio/nixos-config#pio'
alias nf='nix flake update /home/pio/nixos-config'
alias nsu='nf && ns'

# Generations and GC
auth() { sudo -v; }
alias sys-gen='auth && sudo nix profile history --profile /nix/var/nix/profiles/system'
alias usr-gen='nix profile history'
alias sys-gc='auth && sudo nix-collect-garbage'
alias usr-gc='nix-collect-garbage'
alias sys-gc-old='auth && sudo nix-collect-garbage --delete-older-than 7d'
alias usr-gc-old='nix profile wipe-history --older-than 30d'

# HM helpers (if installed)
alias hm-gen='home-manager generations'
alias hm-expire='home-manager expire-generations "30 days ago"'
```
Reload your shell after adding aliases:
```bash
source ~/.bashrc
```

## Notes

- Hardware is loaded from `/etc/nixos/hardware-configuration.nix` so evaluation reads outside the flake. That’s why we use `--impure`.
- Package versions are pinned via `flake.lock`. Using `--impure` here does not affect package versions; it only allows reading `/etc`.
- For fully pure/reproducible hosts, commit per-host hardware modules inside the repo and reference them directly. 