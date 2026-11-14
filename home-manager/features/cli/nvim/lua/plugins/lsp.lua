return {
	{ -- Lua LSP support for the Neovim API and plugins
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
		},
	},

	{ "j-hui/fidget.nvim", opts = {} }, -- LSP progress

	{
		-- Provides default server configs (lsp/*.lua) for vim.lsp.config
		"neovim/nvim-lspconfig",
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", Snacks.picker.lsp_definitions, "[G]oto [D]efinition")
					map("gr", Snacks.picker.lsp_references, "[G]oto [R]eferences")
					map("gI", Snacks.picker.lsp_implementations, "[G]oto [I]mplementation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("<leader>D", Snacks.picker.lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", Snacks.picker.lsp_symbols, "[D]ocument [S]ymbols")
					map("<leader>ws", Snacks.picker.lsp_workspace_symbols, "[W]orkspace [S]ymbols")
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- Highlight references of the word under the cursor while it rests
					if client and client:supports_method("textDocument/documentHighlight") then
						local group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = group,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = group,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client and client:supports_method("textDocument/inlayHint") then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- nixd gets nixpkgs and option completions from this flake
			local nix = require("nix_paths")
			local flake = '(builtins.getFlake "' .. nix.flake .. '")'
			local host = vim.fn.hostname():gsub("%..*$", "")
			local system_options = vim.fn.has("mac") == 1 and (flake .. ".darwinConfigurations." .. host .. ".options")
				or (flake .. ".nixosConfigurations." .. host .. ".options")

			-- Servers are installed by Nix (see neovim.nix)
			local servers = {
				nixd = {
					settings = {
						nixd = {
							nixpkgs = { expr = "import " .. flake .. ".inputs.nixpkgs { }" },
							formatting = { command = { "nixfmt" } },
							options = {
								system = { expr = system_options },
								home_manager = {
									expr = flake .. '.homeConfigurations."' .. nix.username .. "@" .. host .. '".options',
								},
							},
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = { completion = { callSnippet = "Replace" } },
					},
				},
				basedpyright = {},
				ruff = {},
				gopls = {},
				vtsls = {},
				rust_analyzer = {},
				bashls = {},
				yamlls = {},
				marksman = {},
			}

			for name, server in pairs(servers) do
				vim.lsp.config(name, server)
				vim.lsp.enable(name)
			end
		end,
	},
}
