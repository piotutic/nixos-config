{ pkgs, ... }:

{
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "github.com" "gist.github.com" ];
    };
    settings = {
      editor = "vim";
      git_protocol = "https";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
        pc = "pr create";
        rc = "repo clone";
        rv = "repo view";
        rl = "repo list";
      };
    };
    extensions = with pkgs; [
      gh-dash
    ];
  };

  programs.gh-dash = {
    enable = true;
    settings = {
      prSections = [
        {
          title = "My Pull Requests";
          filters = "is:open author:@me";
        }
        {
          title = "Needs My Review";
          filters = "is:open review-requested:@me";
        }
        {
          title = "Recently Updated";
          filters = "is:open sort:updated-desc";
        }
      ];
      issuesSections = [
        {
          title = "My Issues";
          filters = "is:open author:@me";
        }
        {
          title = "Assigned to Me";
          filters = "is:open assignee:@me";
        }
      ];
    };
  };
}
