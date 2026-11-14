local c = require("nix").colors

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,

		border_size = 2,

		col = {
			active_border = { colors = { "rgb(" .. c.blue .. ")", "rgb(" .. c.magenta .. ")" }, angle = 45 },
			inactive_border = "rgb(" .. c.bgHighlight .. ")",
		},

		resize_on_border = false,
		allow_tearing = true, -- only for windows matched by the tearing rules
		layout = "dwindle",
	},

	decoration = {
		rounding = 8,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(" .. c.bgDark .. "ee)",
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "master",
	},
	scrolling = {
		fullscreen_on_one_column = true,
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = false,
		-- Switch to an app when it asks for focus (e.g. a clicked link opening in Zen).
		focus_on_activate = true,
	},
	-- Desktop stays SDR; fullscreen HDR content switches the monitor to HDR.
	render = {
		cm_auto_hdr = 1,
	},
})

-- stylua: ignore start
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 } } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",           enabled = true, speed = 8,   bezier = "default" })
hl.animation({ leaf = "border",           enabled = true, speed = 4.3, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",          enabled = true, speed = 5.6, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 4.4, spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 4.4, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",           enabled = true, speed = 1.4, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",          enabled = true, speed = 1.2, bezier = "almostLinear" })
hl.animation({ leaf = "fade",             enabled = true, speed = 2.4, bezier = "quick" })
hl.animation({ leaf = "layers",           enabled = true, speed = 4.8, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "layersIn",         enabled = true, speed = 4.8, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "layersOut",        enabled = true, speed = 4.8, bezier = "linear",       style = "slide" })
hl.animation({ leaf = "fadeLayersIn",     enabled = true, speed = 1.4, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut",    enabled = true, speed = 1.1, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 4.4, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesIn",     enabled = true, speed = 4.4, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesOut",    enabled = true, speed = 4.4, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4.4, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "zoomFactor",       enabled = true, speed = 5.6, bezier = "quick" })
-- stylua: ignore end
