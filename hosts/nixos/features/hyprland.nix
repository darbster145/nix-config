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
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    HYPRSHOT_DIR = "/home/brad/Pictures";
    GDK_DISABLE = "gles-api";
    GSK_RENDERER = "gl";
  };

  # Bar, idle, wallpaper, notifications, clipboard, etc. are installed and
  # run by home-manager (home-manager/features/hyprland).
  environment.systemPackages = with pkgs; [
    brightnessctl
    pavucontrol
    wireguard-tools
    cargo
    hyprshot
    wl-clipboard
    playerctl
    hyprcursor
    nwg-look
    walker
    networkmanagerapplet
  ];

  services.elephant = {
    enable = true;
  };

  # Only run walker's backend in Hyprland, not in KDE sessions.
  systemd.user.services.elephant.unitConfig.ConditionEnvironment = "XDG_CURRENT_DESKTOP=Hyprland";

  systemd.user.services.elephant.serviceConfig.Environment = [
    "PATH=${pkgs.bash}/bin:${pkgs.coreutils}/bin:/run/wrappers/bin:/home/brad/.nix-profile/bin:/home/brad/.local/state/nix/profile/bin:/etc/profiles/per-user/brad/bin:/nix/profile/bin:/run/current-system/sw/bin"
  ];

  # Needed system-wide for hyprlock's PAM service.
  programs.hyprlock = {
    enable = true;
  };

  services.gvfs.enable = true;

}
