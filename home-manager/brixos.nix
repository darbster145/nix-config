# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      writeShellApplication = args:
        prev.writeShellApplication (
          if args.name == "polaris-gamescope-session" then
            args
            // {
              # Polaris currently triggers these ShellCheck false positives
              # for a lock flag intentionally exported from subshells.
              excludeShellChecks = (args.excludeShellChecks or [ ]) ++ [ "SC2030" "SC2031" ];
            }
          else
            args
        );
    })
  ];

  imports = [
    ./global/default.nix
    ./features/base/default.nix
    ./features/cli/tmux.nix
    ./features/cli/yazi.nix
    ./features/cli/zoxide.nix
    ./features/development/kubernetes.nix
    ./features/development/version-control.nix
    ./features/desktop/apps.nix
    ./features/cli/starship.nix
    ./features/desktop/opencode.nix
    ./features/desktop/zen-browser.nix
    ./features/desktop/ghostty.nix
    ./features/hyprland/default.nix
    ./features/desktop/codex-desktop.nix
    inputs.polaris.homeModules.polaris
  ];

  services.polaris = {
    enable = true;
    streamMode = "gamescope_stream";
  }
  // import ../hosts/nixos/brixos/polaris-packages.nix { inherit inputs pkgs; };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  home = {
    username = "brad";
    homeDirectory = "/home/brad";
  };

  home.packages = with pkgs; [
  ];
}
