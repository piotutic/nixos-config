{ lib, pkgs, ... }:

{
  # Self-hosted GitHub Actions runner for piotutic/clippod.
  # Registration needs a fine-grained PAT (repo Administration read/write) in
  # tokenFile, root-only, no trailing newline. The clippod CI only targets this
  # runner while the repo's CI_RUNNER Actions variable is "self-hosted" —
  # deleting that variable falls CI back to GitHub-hosted runners without a
  # config change here.
  services.github-runners.clippod = {
    enable = true;
    url = "https://github.com/piotutic/clippod";
    tokenFile = "/var/lib/secrets/github-runner.token";
    replace = true;
    extraLabels = [ "hp-laptop" ];
    # Jobs work on disk, not in the default RuntimeDirectory (/run, a 3.8 GB RAM
    # tmpfs): a checkout + node_modules + venv pinned 1-2 GB of RAM per run, could
    # fill /run, and sat on another filesystem than the pnpm store (RUNNER_ROOT,
    # /var/lib), so pnpm copied instead of hard-linking. A systemd-managed
    # CacheDirectory is created and owned for the service's DynamicUser, and is
    # writable inside its sandbox; the service empties workDir on every start.
    # Under DynamicUser systemd keeps it at /var/cache/private/... behind a
    # /var/cache/... symlink: workDir must be the REAL path, because
    # actions/checkout scopes its credentials with a git `includeIf gitdir:` on the
    # workspace path while git resolves the symlink, so the token never applied
    # ("could not read Username", 2026-10-17).
    workDir = "/var/cache/private/github-runner-work/clippod";
    serviceOverrides = {
      CacheDirectory = [ "github-runner-work/clippod" ];
      # The module binds a non-null workDir (BindPaths). Under DynamicUser the
      # cache dir is a symlink into /var/cache/private, and that bind left it
      # unwritable ("ln: ... _diag: Permission denied", 2026-10-17); systemd
      # already makes its own CacheDirectory writable, so the bind is dropped.
      BindPaths = lib.mkForce [ ];
    };
    extraPackages = with pkgs; [
      nodejs_24
      pnpm
      uv
      git
    ];
  };
}
