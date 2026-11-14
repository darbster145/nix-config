{
  pkgs,
  lib,
  config,
  ...
}:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "darbster145";
        email = "swoopmaster22@proton.me";
      };

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
      merge.conflictStyle = "zdiff3";
    };
  };

  # Syntax-highlighted diffs for git diff/log/show (theme comes from bat.nix)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true; # n/N jump between files
      line-numbers = true;
      side-by-side = true;
      syntax-theme = "tokyonight_night";
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
