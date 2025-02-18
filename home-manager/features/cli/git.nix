{ pkgs, lib, config, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "swoopmaster22@proton.me";
    userName = "darbster145";
    aliases = {
      gp = "git pull";
      gc = "git commit";
      gs = "git status";
    };
  };
}

