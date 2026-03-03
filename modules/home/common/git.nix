{ ... }:

{
  programs.git = {
    enable = true;

    ignores = [
      ".nix/"
      "**/.claude/settings.local.json"
    ];

    settings = {
      user = {
        name = "piotutic";
        email = "piotutic@yahoo.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictStyle = "zdiff3";
      diff.algorithm = "histogram";
      log.date = "iso";
      core.autocrlf = "input";
      core.ignoreCase = false;
      branch.autoSetupRebase = "always";
      rerere.enabled = true;

      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        cob = "checkout -b";
        com = "checkout main";
        cod = "checkout develop";
        ca = "commit -a";
        cam = "commit -am";
        amend = "commit --amend";
        amendn = "commit --amend --no-edit";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        lga = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
        lol = "log --oneline";
        lola = "log --oneline --all";
        df = "diff";
        dfc = "diff --cached";
        dfh = "diff HEAD~1";
        s = "status -s";
        ss = "status";
        info = "remote -v";
        sl = "stash list";
        sa = "stash apply";
        ssh = "stash show";
        sp = "stash pop";
        r = "reset";
        r1 = "reset HEAD^";
        r2 = "reset HEAD^^";
        rh = "reset --hard";
        rh1 = "reset HEAD^ --hard";
        rh2 = "reset HEAD^^ --hard";
        rem = "remote";
        rema = "remote add";
        remr = "remote rm";
        remv = "remote -v";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
    };
  };
}
