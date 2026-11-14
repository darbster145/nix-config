let
  c = import ./palette.nix;
  rgb = color: "rgb(${c.hex color})";
in
{
  # GNOME-style lock screen: blurred desktop, big centred clock, rounded input.
  programs.hyprlock = {
    enable = true;
    settings = {
      general.hide_cursor = true;

      animations = {
        enabled = true;
        bezier = [ "linear, 1, 1, 0, 0" ];
        animation = [
          "fadeIn, 1, 4, linear"
          "fadeOut, 1, 4, linear"
          "inputFieldDots, 1, 2, linear"
        ];
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          brightness = 0.6;
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:60000] date +"%A, %B %-d"'';
          color = rgb c.fg;
          font_size = 20;
          font_family = "Adwaita Sans";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "$TIME";
          color = rgb c.fg;
          font_size = 96;
          font_family = "Adwaita Sans Bold";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];

      "input-field" = [
        {
          monitor = "";
          size = "300, 48";
          outline_thickness = 1;
          rounding = 10;
          inner_color = rgb c.bg;
          outer_color = rgb c.border;
          check_color = rgb c.blue;
          fail_color = rgb c.red;
          font_color = rgb c.fg;
          font_family = "Adwaita Sans";
          fade_on_empty = false;
          placeholder_text = "Password";
          fail_text = "$PAMFAIL";
          dots_spacing = 0.3;
          position = "0, -120";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
