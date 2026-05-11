{
  config,
  lib,
  pkgs,
  llm-agents-pkgs,
  ...
}: let
  cfg = config.pio.hermes-agent;
  yaml = pkgs.formats.yaml {};

  baseSettings = {
    model = {
      default = cfg.model;
      provider = cfg.provider;
      base_url = cfg.baseUrl;
    };

    terminal = {
      backend = "local";
      cwd = ".";
      timeout = 180;
      shell_init_files = [
        "~/.zshrc"
      ];
    };

    agent = {
      max_turns = 90;
      api_max_retries = 3;
      disabled_toolsets = [];
    };

    display = {
      personality = "technical";
      show_reasoning = false;
      bell_on_complete = false;
      streaming = true;
      final_response_markdown = "strip";
      busy_input_mode = "interrupt";
      persistent_output = true;
      persistent_output_max_lines = 200;
      inline_diffs = true;
      user_message_preview = {
        first_lines = 2;
        last_lines = 2;
      };
    };

    compression = {
      enabled = true;
      threshold = 0.50;
      target_ratio = 0.20;
      protect_last_n = 20;
    };

    memory = {
      memory_enabled = true;
      user_profile_enabled = true;
    };

    security = {
      redact_secrets = true;
      tirith_enabled = true;
      tirith_path = "tirith";
      tirith_timeout = 5;
      tirith_fail_open = true;
    };

    logging = {
      level = "INFO";
      max_size_mb = 5;
      backup_count = 3;
    };

    sessions = {
      auto_prune = true;
      retention_days = 90;
      min_interval_hours = 24;
      vacuum_after_prune = true;
    };

    checkpoints = {
      enabled = false;
      auto_prune = true;
      retention_days = 7;
      max_total_size_mb = 500;
      max_file_size_mb = 10;
    };
  };
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

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional Hermes config.yaml settings merged over the defaults from this module.";
    };
  };

  config = {
    home.packages = [
      llm-agents-pkgs.hermes-agent
    ];

    home.file.".hermes/config.yaml".source =
      yaml.generate "hermes-config.yaml" (lib.recursiveUpdate baseSettings cfg.settings);

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
