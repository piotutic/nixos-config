# NixOS Configuration

Multi-device NixOS config using flakes and Home Manager. The repo is organized around explicit capability imports: if a host imports a module, it gets that capability. If it does not import the module, that capability does not exist on that machine.

## Mental Model

- `modules/system/common/`: baseline NixOS config shared across almost every machine
- `modules/system/optional/`: opt-in system capabilities such as `gui`, `docker`, `nvidia`, `portable`
- `modules/home/common/`: baseline Home Manager config shared across machines
- `modules/home/optional/`: opt-in user-space packages and tooling
- `hosts/<name>/`: each host composes the exact system and home modules it needs

There are no global feature toggles. Hosts are the source of truth.

## Structure

```text
nixos-config/
├── flake.nix
├── hosts/
│   ├── hp-laptop/
│   │   ├── default.nix
│   │   ├── system.nix
│   │   └── home.nix
│   ├── zenith/
│   │   ├── default.nix
│   │   ├── system.nix
│   │   └── home.nix
│   └── hardware/
│       ├── hp-laptop.nix
│       └── zenith.nix
└── modules/
    ├── system/
    │   ├── common/
    │   └── optional/
    │       ├── gui/
    │       ├── docker.nix
    │       ├── mullvad.nix
    │       ├── plymouth.nix
    │       ├── nvidia.nix
    │       ├── gaming.nix
    │       ├── portable.nix
    │       ├── power-management.nix
    │       └── auto-commit.nix
    └── home/
        ├── common/
        └── optional/
            ├── development.nix
            ├── llm-agents.nix
            ├── openclaw.nix
            └── video-editing.nix
```

## Quick Start

```bash
update
upgrade
nix-gc
```

## Current Hosts

- `hp-laptop`
  - system: `common`, `gui`, `mullvad`, `plymouth`, `auto-commit`, `portable`, `power-management`
  - home: `common`, `development`, `llm-agents`, `openclaw`
- `zenith`
  - system: `common`, `gui`, `docker`, `mullvad`, `plymouth`, `auto-commit`, `nvidia`, `gaming`
  - home: `common`, `development`, `llm-agents`, `openclaw`, `video-editing`

## Capability Modules

System modules are imported directly by host files.

- `gui`
  - GNOME session, GUI packages, Flatpak, Bluetooth, desktop services
- `docker`
  - rootless Docker and tooling
  - optional knob: `pio.docker.startOnBoot`
- `mullvad`
  - Mullvad VPN and WireGuard support
- `plymouth`
  - boot splash and quiet boot settings
- `nvidia`
  - NVIDIA drivers, 32-bit graphics support
  - optional knob: `pio.nvidia.cuda`
- `gaming`
  - Steam, Proton, GameMode
- `portable`
  - lid and suspend behavior
  - optional knobs: `pio.portable.lidAction`, `pio.portable.suspendEnabled`
- `power-management`
  - TLP and AC vs battery tuning
- `auto-commit`
  - installs `nixos-auto-commit`

Home modules are also imported directly by host files.

- `development`
  - CLI/dev packages
- `llm-agents`
  - Codex, Claude Code, Gemini CLI, and OpenCode
- `openclaw`
  - imports the upstream OpenClaw Home Manager module and enables it with upstream defaults
- `video-editing`
  - `ffmpeg-full`, `davinci-resolve`

## Adding a New Host

### 1. Generate hardware config on the target machine

```bash
sudo nixos-generate-config --show-hardware-config > hardware.nix
```

### 2. Copy hardware config into the repo

```bash
cp hardware.nix ~/nixos-config/hosts/hardware/mydevice.nix
```

### 3. Create the host folder

Create `hosts/mydevice/default.nix`:

```nix
{ ... }:

{
  imports = [
    ../hardware/mydevice.nix
    ./system.nix
  ];

  home-manager.users.pio = import ./home.nix;
}
```

Create `hosts/mydevice/system.nix`:

```nix
{ ... }:

{
  imports = [
    ../../modules/system/common
    ../../modules/system/optional/gui
    ../../modules/system/optional/mullvad.nix
  ];
}
```

Create `hosts/mydevice/home.nix`:

```nix
{ ... }:

{
  imports = [
    ../../modules/home/common
    ../../modules/home/optional/development.nix
    ../../modules/home/optional/llm-agents.nix
    ../../modules/home/optional/openclaw.nix
  ];
}
```

### 4. Add the host to `flake.nix`

```nix
nixosConfigurations = {
  hp-laptop = mkHost "hp-laptop";
  zenith = mkHost "zenith";
  mydevice = mkHost "mydevice";
};
```

### 5. Build it

```bash
sudo nixos-rebuild switch --flake .#mydevice
```

## Common Customizations

### Add a capability to one host

Add the module import to `hosts/<name>/system.nix` or `hosts/<name>/home.nix`.

Example: enable Docker only on `zenith`:

```nix
{
  imports = [
    ../../modules/system/common
    ../../modules/system/optional/gui
    ../../modules/system/optional/docker.nix
  ];
}
```

### Adjust behavior inside an imported capability

Use the small set of remaining knobs only when the capability is already imported.

Example: change lid behavior on `hp-laptop`:

```nix
{
  imports = [
    ../../modules/system/common
    ../../modules/system/optional/portable.nix
  ];

  pio.portable.lidAction = "ignore";
}
```

## Maintenance

```bash
nix flake update
nixos-rebuild list-generations
sudo nixos-rebuild switch --rollback
sudo nixos-rebuild test --flake .
```
