let
  c = import ../palette.nix;
in
{
  programs.waybar = {
    style = ''
      * {
          border: none;
          border-radius: 0;
          min-height: 0;
          font-family: "Adwaita Sans", "Symbols Nerd Font";
          font-size: 14px;
          font-weight: bold;
      }

      window#waybar {
          background: ${c.bgDark};
          color: ${c.fg};
      }

      tooltip {
          background: ${c.bg};
          border: 1px solid ${c.border};
          border-radius: 8px;
      }

      tooltip label {
          color: ${c.fg};
          font-weight: normal;
          padding: 4px;
      }

      /* Workspaces: dots, with the active one stretched into a pill */
      #workspaces {
          margin: 4px 4px;
          padding: 0 8px;
          border-radius: 8px;
      }

      #workspaces:hover {
          background: ${c.bgHighlight};
      }

      #workspaces button {
          min-width: 7px;
          min-height: 7px;
          margin: 9px 3px;
          padding: 0;
          border-radius: 999px;
          background: ${c.comment};
          transition: min-width 150ms ease;
      }

      /* Labels are empty; keep them from reserving text height */
      #workspaces button label {
          font-size: 1px;
      }

      #workspaces button.active {
          min-width: 34px;
          background: ${c.blue};
      }

      #workspaces button.urgent {
          background: ${c.red};
      }

      /* Centre clock */
      #clock {
          margin: 4px 0;
          padding: 0 12px;
          border-radius: 8px;
      }

      #clock:hover {
          background: ${c.bgHighlight};
      }

      /* Status pill on the right */
      #status {
          margin: 4px 4px;
          padding: 0 6px;
          border-radius: 8px;
      }

      #status:hover {
          background: ${c.bgHighlight};
      }

      #tray,
      #pulseaudio,
      #power-profiles-daemon,
      #battery,
      #custom-power {
          padding: 0 6px;
      }

      #pulseaudio,
      #power-profiles-daemon,
      #custom-power {
          font-size: 16px;
      }

      #power-profiles-daemon.performance {
          color: ${c.magenta};
      }

      #power-profiles-daemon.power-saver {
          color: ${c.green};
      }

      #battery.warning:not(.charging) {
          color: ${c.yellow};
      }

      #battery.critical:not(.charging) {
          color: ${c.red};
      }

      #tray > .needs-attention {
          background: alpha(${c.red}, 0.6);
          border-radius: 8px;
      }
    '';
  };
}
