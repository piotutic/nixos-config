{ llm-agents-pkgs, ... }:

{
  home.packages = [
    llm-agents-pkgs.codex
    llm-agents-pkgs.claude-code
  ];
}
