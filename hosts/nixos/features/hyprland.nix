{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  environment.systemPackages = with pkgs; [
    wlogout
    brightnessctl
    hypridle
    waybar
    brightnessctl
    pavucontrol
    wireguard-tools
    cargo
    wlogout
    hyprshot
    hyprlock
    wl-clipboard
    clipse
    rofi-wayland
    wofi
    playerctl
    nautilus
    swww
    hyprpaper
    dunst
    hyprcursor
    nwg-look
    libsForQt5.kwallet
    kdePackages.kwallet
    kdePackages.kwallet-pam
    walker
  ];

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      tumbler
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

  environment.sessionVariables = {
    "HYPRSHOT_DIR" = "/home/brad/Pictures";
    "GDK_DISABLE" = "gles-api";
    "GSK_RENDERER" = "gl";
  };
}
