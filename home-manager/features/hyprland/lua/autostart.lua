local nix = require("nix")

-- Long-running helpers (waybar, hypridle, hyprpaper, dunst, swayosd,
-- polkit agent, udiskie) are systemd user services. blueman-applet comes
-- from XDG autostart.
hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm finalize")
	-- Hands the login password to KWallet. Plasma runs this itself; its
	-- autostart entry is skipped under systemd, so Hyprland must run it.
	hl.exec_cmd(nix.kwallet_init)
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("walker --gapplication-service")
end)
