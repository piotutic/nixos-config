{ llm-agents-pkgs, ... }:

{
  home.packages = [
    llm-agents-pkgs.codex
    llm-agents-pkgs.claude-code
    llm-agents-pkgs.gemini-cli
    llm-agents-pkgs.opencode
  ];
}
