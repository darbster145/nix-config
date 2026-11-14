let
  c = import ./palette.nix;
in
{
  # GNOME-style notifications: dark rounded cards dropping from the top centre.
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Adwaita Sans 11";
        origin = "top-center";
        offset = "(0, 12)";
        width = 400;
        height = "(0, 200)";
        gap_size = 6;
        padding = 12;
        horizontal_padding = 14;
        frame_width = 1;
        frame_color = c.border;
        corner_radius = 10;
        separator_height = 0;
        enable_recursive_icon_lookup = true;
        icon_theme = "Adwaita, hicolor";
        max_icon_size = 32;
        icon_corner_radius = 6;
        format = "<b>%s</b>\\n%b";
      };

      urgency_low = {
        background = c.bg;
        foreground = c.fg;
        timeout = 5;
      };

      urgency_normal = {
        background = c.bg;
        foreground = c.fg;
        timeout = 8;
      };

      urgency_critical = {
        background = c.bg;
        foreground = c.fg;
        frame_color = c.red;
        timeout = 0;
      };
    };
  };
}
