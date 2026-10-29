{ ... }:

{
  imports = [
    ../../modules/system/common
    ../../modules/system/optional/gui
    ../../modules/system/optional/mullvad.nix
    ../../modules/system/optional/tailscale.nix
    ../../modules/system/optional/plymouth.nix
    ../../modules/system/optional/auto-commit.nix
    ../../modules/system/optional/portable.nix
    ../../modules/system/optional/power-management.nix
    ../../modules/system/optional/github-runner.nix
    ../../modules/system/optional/docker.nix
    ../../modules/system/optional/system-health.nix
  ];

  pio.portable.lidAction = "ignore";

  # Keep the Hermes user services (home/optional/hermes-agent.nix) running
  # without an active login session.
  users.users.pio.linger = true;
}
