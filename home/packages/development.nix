# Development tools - for all devices
{ pkgs, claude-code-nix, ... }:

{
  home.packages = with pkgs; [
    wget
    curl
    just
    tmux
    jq
    vscode-fhs # FHS-compliant VSCode for better extension compatibility
    gnumake
    claude-code-nix
  ];
}
