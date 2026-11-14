local p = require("programs")

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "float-pavucontrol",
	match = { class = "org.pulseaudio.pavucontrol" },
	float = true,
})

hl.window_rule({
	name = "float-satty",
	match = { class = "com.gabm.satty" },
	float = true,
	center = true,
})

hl.window_rule({
	name = "float-bluetooth",
	match = { class = "blueman-manager" },
	float = true,
	center = true,
})

-- Drop-down terminal (SUPER+SHIFT+T): starts on first toggle, then shows/hides.
hl.workspace_rule({
	workspace = "special:dropdown",
	on_created_empty = p.terminal .. " --class=dropdown.ghostty",
})

hl.window_rule({
	name = "dropdown-terminal",
	match = { class = "dropdown.ghostty" },
	float = true,
	size = { "monitor_w * 0.6", "monitor_h * 0.5" },
	move = { "monitor_w * 0.2", "50" },
})

-- Steam's small windows float instead of tiling.
hl.window_rule({
	name = "float-steam-dialogs",
	match = {
		class = "^steam$",
		title = "^(Friends List|Steam Settings|Special Offers|Screenshot Manager|Steam - News.*|.* - Chat)$",
	},
	float = true,
	center = true,
})

-- Let games tear for lower latency.
hl.window_rule({
	name = "tearing-games",
	match = { content = "game" },
	immediate = true,
})

hl.window_rule({
	name = "tearing-steam-games",
	match = { class = "^(steam_app_.*|gamescope)$" },
	immediate = true,
})

hl.window_rule({
	name = "idle-inhibit-fullscreen",
	match = { class = ".*" },
	idle_inhibit = "fullscreen",
})
