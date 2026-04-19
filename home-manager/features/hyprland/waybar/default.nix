{
  
  imports = [
    ./settings.nix
    ./styles.nix
  ];

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = [ "hyprland-session.target" ];
    };
  };

}
