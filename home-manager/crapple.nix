# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: 

{
  imports = [
    ./global/default.nix
    ./features/development/kubernetes.nix
    ./features/development/version-control.nix
    ./features/desktop/apps.nix
    ./features/desktop/ghostty.nix
    ./features/desktop/opencode.nix
    ./features/desktop/aerospace.nix
    ./features/desktop/oh-my-posh.nix
    ./features/desktop/zen-browser.nix
    ./features/cli/default.nix
  ];
  home = {
    username = "brad";
    homeDirectory = "/Users/brad";
  };

  home.packages = with pkgs; [
  ];
}
