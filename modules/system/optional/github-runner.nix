{ pkgs, ... }:

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
    extraPackages = with pkgs; [
      nodejs_24
      pnpm
      uv
      git
    ];
  };
}
