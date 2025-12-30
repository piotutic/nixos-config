# Base packages - fonts and CLI utilities for all devices
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerd-fonts.jetbrains-mono

    # System Monitoring
    btop

    # CLI Utilities
    eza
    bat
    fd
    ripgrep
    alejandra # Nix formatter
  ];
}
