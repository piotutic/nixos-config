{
  config,
  inputs,
  lib,
  pkgs,
  llm-agents-pkgs,
  ...
}: let
  cfg = config.services.hermes-agent;
  # MagicDNS name of this machine (modules/system/optional/tailscale.nix).
  # Hermes Conduit must connect with exactly this name: the dashboard rejects
  # any other Host header.
  tailnetHost = "hp-laptop.tailcd6693.ts.net";
  chromeBin = "${pkgs.google-chrome}/bin/google-chrome-stable";
in {
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  # The hermes CLI and the desktop app. Both share HERMES_HOME with the services.
  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;

    # The module bakes HERMES_MANAGED=home-manager into the launcher, which
    # locks every settings change. Unlock it after the module's env is set.
    desktop.package = let
      base = config.programs.hermes-agent.package.hermesDesktop;
    in
      base
      // {
        override = args:
          base.override (args
            // {
              extraRun = (args.extraRun or []) ++ ["export HERMES_MANAGED=false"];
            });
      };
  };

  # Gateway (Telegram, Discord, ...) plus the web dashboard, served on the
  # tailnet only (http://${tailnetHost}:9119) for Hermes Conduit. A non-loopback
  # bind requires dashboard login (dashboard.basic_auth in config.yaml), and the
  # backend refuses to start without it. Gated backends reject a desktop
  # session token, so the desktop app spawns its own loopback backend.
  # No settings/environmentFiles: config.yaml and .env stay owned by the app,
  # `hermes config edit` and `hermes config set`, and survive rebuilds.
  services.hermes-agent = {
    enable = true;
    gateway.enable = true;

    backend = {
      mode = "dashboard";
      host = tailnetHost;
      # tailscaled is a system unit, so the user unit polls until the name
      # resolves instead of ordering after it.
      waitFor = "hostname";
    };

    # The units get a fixed PATH, so tools from the user profile must be listed
    # here. gh backs git's GitHub credential helper; claude/codex let the agent
    # delegate coding via the bundled skills.
    extraPackages = with pkgs;
      [
        curl
        ffmpeg
        jq
        nodejs_22
        ripgrep
        tirith
      ]
      ++ [
        config.programs.gh.package
        llm-agents-pkgs.agent-browser
        llm-agents-pkgs.claude-code
        llm-agents-pkgs.codex
      ];
  };

  # Keep config live-editable, as before: override HERMES_MANAGED in the units
  # (later Environment= entries win) and drop the marker the shell reads.
  # The units don't see session variables, so the browser tools also get
  # agent-browser's Chrome path here (see llm-agents.nix).
  systemd.user.services.hermes-agent.Service.Environment = lib.mkAfter [
    "HERMES_MANAGED=false"
    "AGENT_BROWSER_EXECUTABLE_PATH=${chromeBin}"
  ];
  systemd.user.services.hermes-backend.Service.Environment = lib.mkAfter [
    "HERMES_MANAGED=false"
    "AGENT_BROWSER_EXECUTABLE_PATH=${chromeBin}"
  ];

  home.activation = {
    hermesAgentUnmanage = lib.hm.dag.entryAfter ["hermesAgentSetup"] ''
      run rm -f ${lib.escapeShellArg "${cfg.hermesHome}/.managed"}
    '';
  };
}
