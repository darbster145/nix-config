local prettier = { "prettierd" }

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = { c = true, cpp = true }
			return {
				timeout_ms = 500,
				lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback",
			}
		end,
		formatters_by_ft = {
			nix = { "nixfmt" },
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format" },
			go = { "gofumpt" },
			rust = { "rustfmt" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			javascript = prettier,
			javascriptreact = prettier,
			typescript = prettier,
			typescriptreact = prettier,
			json = prettier,
			jsonc = prettier,
			css = prettier,
			html = prettier,
			yaml = prettier,
			markdown = prettier,
		},
	},
}
