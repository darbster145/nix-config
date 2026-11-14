{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config.theme = "tokyonight_night";
    # Also used by delta for syntax highlighting in diffs
    themes.tokyonight_night = {
      src = pkgs.vimPlugins.tokyonight-nvim;
      file = "extras/sublime/tokyonight_night.tmTheme";
    };
  };
}
