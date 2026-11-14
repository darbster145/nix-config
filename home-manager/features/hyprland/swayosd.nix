{ pkgs, ... }:

let
  c = import ./palette.nix;
in

{
  # GNOME-style volume/brightness popup, driven by swayosd-client in the keybinds.
  services.swayosd = {
    enable = true;
    topMargin = 0.85;
    stylePath = pkgs.writeText "swayosd.css" ''
      window#osd {
          border-radius: 12px;
          background: alpha(${c.bg}, 0.95);
          border: 1px solid ${c.border};
      }

      window#osd #container {
          margin: 14px 20px;
      }

      window#osd image,
      window#osd label {
          color: ${c.fg};
      }

      window#osd progressbar,
      window#osd trough,
      window#osd progress {
          min-height: 6px;
          border-radius: 999px;
          border: none;
      }

      window#osd trough {
          background: ${c.bgHighlight};
      }

      window#osd progress {
          background: ${c.blue};
      }
    '';
  };
}
