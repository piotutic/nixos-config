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
  # The plugin selection is the only Nix-managed config key; Home Manager
  # deep-merges it into config.yaml. Other settings and .env remain app-owned.
  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    # The source is already installed under hermesHome/plugins.
    settings.plugins.enabled = [ "conduit_push" ];

    backend = {
      mode = "dashboard";
      host = tailnetHost;
      # tailscaled is a system unit, so the user unit polls until the name
      # resolves instead of ordering after it.
      waitFor = "hostname";
    };

    # The units get a fixed PATH, so tools from the user profile must be listed
    # here. gh backs git's GitHub credential helper; claude/codex let the agent
    # delegate coding via the bundled skills. systemd provides systemd-run for
    # kanban/cron worker scopes.
    extraPackages = with pkgs;
      [
        curl
        docker-client
        ffmpeg
        jq
        nodejs_22
        ripgrep
        systemd
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
    "DOCKER_HOST=unix:///run/user/1000/docker.sock"
  ];
  systemd.user.services.hermes-backend.Service.Environment = lib.mkAfter [
    "HERMES_MANAGED=false"
    "AGENT_BROWSER_EXECUTABLE_PATH=${chromeBin}"
    "DOCKER_HOST=unix:///run/user/1000/docker.sock"
  ];
  # Sandboxed bot sessions (gateway and dashboard backend) need the rootless
  # daemon up before the Hermes units.
  systemd.user.services.hermes-agent.Unit = {
    Wants = [ "docker.service" ];
    After = [ "docker.service" ];
  };
  systemd.user.services.hermes-backend.Unit = {
    Wants = [ "docker.service" ];
    After = [ "docker.service" ];
  };

  home.activation = {
    hermesAgentUnmanage = lib.hm.dag.entryAfter ["hermesAgentSetup"] ''
      run rm -f ${lib.escapeShellArg "${cfg.hermesHome}/.managed"}
    '';
  };
}
