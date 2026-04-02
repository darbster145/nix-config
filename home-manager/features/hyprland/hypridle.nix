{

  services.hypridle = {
    enable = true;
    settings = {

      # Blank Screen
      listener = [
        {
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

      # Lock Screen
        {
          timeout = 600;
          on-timeout = "hyprlock";
        }

      # Keyboard Backlight
        {
          timeout = 60;
          on-timeout = "brightnessctl -d kbd_backlight set 0";
          on-resume = "brightnessctl -rd kbd_backlight 25";
        }
      ];

      ## TODO Only suspend on battery ###
      # Suspend after 15 Minutes
      # listener = {
      #   timeout = 900;
      #   on-timeout = "systemctl suspend";
      # };
    };
  };

}
