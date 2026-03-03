{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wget
    curl
    just
    tmux
    jq
    vscode-fhs
    gnumake
  ];
}
