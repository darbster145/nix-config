{
  
  imports = [
    ./settings.nix
    ./styles.nix
  ];

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
       targets = [ "graphical-session.target" ];
    };
  };

}
