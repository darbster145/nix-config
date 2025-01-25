{ config, pkgs, ... }:

{
  services = {
    xserver = {
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverridePackages = [ pkgs.mutter ];
        extraGSettingsOverrides = ''
          [org.gnome.mutter]
          experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
        '';
      };
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    };
  };

nixpkgs.overlays = [
  (final: prev: {
    mutter = prev.mutter.overrideAttrs (oldAttrs: {
      # GNOME dynamic triple buffering (huge performance improvement)
      # See https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1441
      src = final.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "vanvugt";
        repo = "mutter";
        rev = "triple-buffering-v4-47";
        hash = "sha256-ajxm+EDgLYeqPBPCrgmwP+FxXab1D7y8WKDQdR95wLI=";
      };

      preConfigure =
        let
          gvdb = final.fetchFromGitLab {
            domain = "gitlab.gnome.org";
            owner = "GNOME";
            repo = "gvdb";
            rev = "2b42fc75f09dbe1cd1057580b5782b08f2dcb400";
            hash = "sha256-CIdEwRbtxWCwgTb5HYHrixXi+G+qeE1APRaUeka3NWk=";
          };
        in
        ''
          cp -a "${gvdb}" ./subprojects/gvdb
        '';
    });
  })
];
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    xterm
    gnome-console
    cheese # webcam tool
    gnome-music
    gnome-contacts
    gnome-terminal
    #gedit # text editor
    epiphany # web browser
    geary # email reader
    #evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
}
