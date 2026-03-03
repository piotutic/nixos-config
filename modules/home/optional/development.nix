{ pkgs, llm-agents-pkgs, ... }:

{
  home.packages = with pkgs; [
    wget
    curl
    just
    tmux
    jq
    vscode-fhs
    gnumake
    llm-agents-pkgs.codex
    llm-agents-pkgs.claude-code
    llm-agents-pkgs.gemini-cli
    llm-agents-pkgs.opencode
  ];
}
