{ pkgs, ... }:

{
  home.pointerCursor = {
    enable = true;
    package = pkgs.banana-cursor;
    name = "banana-cursor";
    hyprcursor.enable = true;
    hyprcursor.size = 24;
  };

  home.packages = with pkgs; [
    adwaita-icon-theme
    papirus-icon-theme
  ];
}
