{ pkgs, ... }:

let
  c = import ./palette.nix;

  # libadwaita/adw-gtk3 named colours, recoloured to Tokyo Night.
  gtkCss = ''
    @define-color accent_color ${c.blue};
    @define-color accent_bg_color ${c.blue};
    @define-color accent_fg_color ${c.bg};
    @define-color window_bg_color ${c.bg};
    @define-color window_fg_color ${c.fg};
    @define-color view_bg_color ${c.bgDark};
    @define-color view_fg_color ${c.fg};
    @define-color headerbar_bg_color ${c.bgDark};
    @define-color headerbar_fg_color ${c.fg};
    @define-color card_bg_color ${c.bgHighlight};
    @define-color card_fg_color ${c.fg};
    @define-color popover_bg_color ${c.bgHighlight};
    @define-color popover_fg_color ${c.fg};
    @define-color dialog_bg_color ${c.bg};
    @define-color dialog_fg_color ${c.fg};
    @define-color sidebar_bg_color ${c.bgDark};
    @define-color sidebar_fg_color ${c.fg};
    @define-color destructive_bg_color ${c.red};
    @define-color success_bg_color ${c.green};
    @define-color warning_bg_color ${c.yellow};
    @define-color error_bg_color ${c.red};
  '';
in
{
  home.pointerCursor = {
    enable = true;
    package = pkgs.banana-cursor;
    name = "Banana";
    hyprcursor.enable = true;
    hyprcursor.size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    font = {
      package = pkgs.adwaita-fonts;
      name = "Adwaita Sans";
      size = 11;
    };
    gtk3.extraCss = gtkCss;
    gtk4.extraCss = gtkCss;
  };

  # Plasma writes these too; let home-manager own them.
  xdg.configFile = {
    "gtk-3.0/settings.ini".force = true;
    "gtk-3.0/gtk.css".force = true;
    "gtk-4.0/settings.ini".force = true;
    "gtk-4.0/gtk.css".force = true;
  };
  gtk.gtk2.force = true;

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  home.packages = [ pkgs.adwaita-icon-theme ];
}
