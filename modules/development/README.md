# Development Modules

Development tools, shell configurations, and development environment setups.

## Modules

- **zsh.nix** - Zsh shell configuration with modern aliases and functions
- **starship.nix** - Starship prompt configuration
- **kitty.nix** - Kitty terminal emulator configuration
- **containers.nix** - Docker/Podman container support for development

## Usage

Shell-related modules (zsh, starship, kitty) are imported in `home.nix` for user-level configuration.
System-level development tools (containers) are imported in `configuration.nix`.