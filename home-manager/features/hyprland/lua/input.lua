hl.config({
	input = {
		kb_layout = "us",
		follow_mouse = 1,
		sensitivity = 0.5,

		touchpad = {
			natural_scroll = true,
			clickfinger_behavior = true,
			disable_while_typing = true,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
