{ llm-agents-pkgs, pkgs, ... }:

{
  home.packages = [
    llm-agents-pkgs.agent-browser
    llm-agents-pkgs.codex
    llm-agents-pkgs.claude-code
    llm-agents-pkgs.claude-desktop
  ];

  # agent-browser would otherwise fetch its own Chromium, and prebuilt
  # binaries don't run on NixOS, so point it at Nix's Chrome.
  home.sessionVariables.AGENT_BROWSER_EXECUTABLE_PATH = "${pkgs.google-chrome}/bin/google-chrome-stable";
}
