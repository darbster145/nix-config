{ inputs, pkgs, ... }:

{
  imports = [
    inputs.codex-desktop-linux.homeManagerModules.codex-desktop-linux
  ];

  programs.codexDesktopLinux = {
    enable = true;
    cliPackage = pkgs.codex;
  };
}
