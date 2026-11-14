let
  # Drop an image here (and `git add` it) to enable the wallpaper on every host.
  wallpaper = ./wallpaper.png;
in
{

  services.hyprpaper = {
    enable = builtins.pathExists wallpaper;
    settings = {

      splash = false;

      wallpaper = [
        {
          monitor = "";
          path = "${wallpaper}";
          fit_mode = "cover";
        }
      ];
    };
  };

}
