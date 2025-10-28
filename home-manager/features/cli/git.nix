{ pkgs, lib, config, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "darbster145";
        email = "swoopmaster22@proton.me";
      };
      aliases = {
        gp = "git pull";
        gc = "git commit";
        gs = "git status";
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
}

