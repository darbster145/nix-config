return {
	-- From Nix so its Rust fuzzy matcher comes prebuilt (see neovim.nix)
	"saghen/blink.cmp",
	dir = require("nix_paths").blink_cmp,
	name = "blink.cmp",
	lazy = false,
	opts = {
		-- <C-n>/<C-p> select, <C-y> accept, <C-space> open, <C-e> close
		keymap = { preset = "default" },
		appearance = { nerd_font_variant = "mono" },
		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 300 },
		},
		signature = { enabled = true },
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "lazydev" },
			providers = {
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},
	},
}
