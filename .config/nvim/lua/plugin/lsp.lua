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

		lsp.ensure_installed({
			"lua-language-server",
			"jedi",
			"ruff",
			"rust-analyzer",
			"yaml-language-server",
			"tsserver",
			"vscode-html-language-server",
			"svelte-language-server"
		})

		-- rust
		require("lspconfig").rust_analyzer.setup({});

		-- python
		require("lspconfig").ruff.setup({
			cmd = { "ruff", "server", "--preview" }
		})
		require("lspconfig").jedi_language_server.setup({
			single_file_support = false
		})

		-- lua
		require('lspconfig').lua_ls.setup({})

		-- yaml
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

		-- typescript
		require("lspconfig").tsserver.setup({
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
						languages = { "javascript", "typescript", "vue" },
					},
				},
			},
			filetypes = {
				"javascript",
				"typescript",
				"vue",
			},
		})

		-- html
		require("lspconfig").html.setup({})

		-- svelte
		require("lspconfig").svelte.setup({})

		vim.diagnostic.config({
			virtual_text = true,
			underline = true,
			signs = false,
		})

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
