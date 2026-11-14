return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{ -- Shows pending keybinds
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			spec = {
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>g", group = "[G]it" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>w", group = "[W]orkspace" },
			},
		},
	},

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{
		"echasnovski/mini.nvim",
		config = function()
			-- Better around/inside textobjects, e.g. va), yinq, ci'
			require("mini.ai").setup({ n_lines = 500 })

			-- Surroundings: saiw) add, sd' delete, sr)' replace
			require("mini.surround").setup()

			-- Icons, also used by oil and the snacks picker
			require("mini.icons").setup()
			MiniIcons.mock_nvim_web_devicons()

			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},

	{ -- Edit directories like a buffer: rename, move and delete files by editing text
		"stevearc/oil.nvim",
		lazy = false,
		dependencies = { "echasnovski/mini.nvim" },
		opts = {
			view_options = { show_hidden = true },
		},
		keys = {
			{ "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
		},
	},
}
