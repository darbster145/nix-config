{ pkgs, lib, config, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "darbster145";
        email = "swoopmaster22@proton.me";
      };

      extraConfig = {
        core = {
          compression = 9;
          whitespace = "error";
          preloadindex = true;
        };
        advice = {
          addEmptyPathspec = false;
          pushNonFastForward = false;
          statusHints = false;
        };
        status = {
          branch = true;
          showStash = true;
          showUntrackedFiles = true;
        };
        diff = {
          context = 3;
          renames = "copies";
          interHunkContext = 10;
        };
        push = {
          autoSetupRemote = true;
          default = "current";
          followTags = true;
        };
        pull = {
          default = "current";
          rebase = true;
        };
        rebase = {
          autoStash = true;
          missingCommitsCheck = "warn";
        };
      };
    };
  };

  # Git shell aliases - following modular pattern (like kubernetes.nix)
  programs.zsh.shellAliases = {
    gs = "git status --short";
    ga = "git add .";
    gd = "git diff";
    gc = "git commit";
    gcl = "git clone";
    gp = "git pull";
    gu = "git push";
    gl = "git log";
    gb = "git branch";
    gi = "git init";
  };
}

