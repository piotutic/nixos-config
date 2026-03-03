{ pkgs, ... }:

{
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerd-fonts.jetbrains-mono
    btop
    eza
    bat
    fd
    ripgrep
    alejandra
  ];
}
