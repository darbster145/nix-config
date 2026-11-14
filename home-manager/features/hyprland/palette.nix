# Tokyo Night (night). Shared by every Hyprland component.
{
  bg = "#1a1b26";
  bgDark = "#16161e";
  bgHighlight = "#292e42";
  border = "#414868";
  fg = "#c0caf5";
  comment = "#565f89";
  blue = "#7aa2f7";
  cyan = "#7dcfff";
  magenta = "#bb9af7";
  green = "#9ece6a";
  yellow = "#e0af68";
  red = "#f7768e";

  # Hyprland/hyprlock colours take hex without the leading "#".
  hex = c: builtins.substring 1 6 c;
}
