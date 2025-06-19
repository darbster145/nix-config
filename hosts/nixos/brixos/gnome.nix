{ config, pkgs, ... }:

{
  services = {
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

  environment.systemPackages =  with pkgs; [
    # Gnome Extensions
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.tiling-assistant
    gnomeExtensions.gsconnect
    gnomeExtensions.hide-top-bar
    gnomeExtensions.date-menu-formatter
    gnomeExtensions.impatience
    gnomeExtensions.media-controls
    gnomeExtensions.open-bar
    gnomeExtensions.quick-web-search
  ];
}
