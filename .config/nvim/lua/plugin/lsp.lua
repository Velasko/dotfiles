return {
	"VonHeikemen/lsp-zero.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local lsp = require('lsp-zero');

		lsp.on_attach(function(_client, buffer)
			lsp.default_keymaps({ buffer });
		end);

		ensure_installed = {
			-- lua
			"lua_ls",

			-- nix
			"rnix",

			-- python
			"ruff",
			"jedi_language_server",

			-- rust
			"rust_analyzer",

			-- yaml
			"yamlls",
		}


		if vim.g.system_distribution:match("nixos") ~= nil then
			table.insert(ensure_installed, "nil_ls")
		end

		-- Mason ref config: https://github.com/williamboman/mason-lspconfig.nvim
		require("mason").setup({ PATH = "append" });
		require("mason-lspconfig").setup({
			ensure_installed = ensure_installed,
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({});
				end,
				["jedi_language_server"] = function()
					require("lspconfig").jedi_language_server.setup({
						single_file_support = false
					})
				end,
				["yamlls"] = function()
					require("lspconfig").yamlls.setup({
						on_attach = function(client, bufnr)
							client.server_capabilities.documentFormattingProvider = true
						end,
						settings = {
							yaml = {
								schemas = {
									["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] =
									"/*.k8s.yaml",
									["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
								},
							},
						},
					})
				end
			},
		});

		local signs = { Error = "!", Warn = "", Hint = "", Info = "" }

		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function()
				local bufnr = vim.lsp.buf.format()
				local clients = vim.lsp.buf_get_clients(bufnr)
				if next(clients) ~= nil then
					vim.lsp.buf.format();
				end
			end
		})
	end
}
