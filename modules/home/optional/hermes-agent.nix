{
  config,
  lib,
  pkgs,
  llm-agents-pkgs,
  ...
}: let
  cfg = config.pio.hermes-agent;
in {
  options.pio.hermes-agent = {
    model = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "anthropic/claude-sonnet-4.5";
      description = "Default Hermes model slug. Leave empty to select interactively or use provider defaults.";
    };

    provider = lib.mkOption {
      type = lib.types.str;
      default = "auto";
      example = "openrouter";
      description = "Hermes model provider.";
    };

    baseUrl = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "http://localhost:11434/v1";
      description = "Optional OpenAI-compatible base URL for custom providers.";
    };
  };

  config = {
    home.packages = [
      llm-agents-pkgs.hermes-agent
    ];

    home.file.".hermes/.env.example".text = ''
      # Copy values from your password manager into ~/.hermes/.env.
      # Do not commit real API keys to nixos-config.
      #
      # Common model providers:
      # OPENROUTER_API_KEY=
      # ANTHROPIC_API_KEY=
      # OPENAI_API_KEY=
      # GEMINI_API_KEY=
      #
      # Optional tool providers:
      # EXA_API_KEY=
      # PARALLEL_API_KEY=
      # FIRECRAWL_API_KEY=
      # TAVILY_API_KEY=
      # FAL_KEY=
      # GITHUB_TOKEN=
    '';
  };
}
