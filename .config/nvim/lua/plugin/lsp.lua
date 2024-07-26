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

		require("lspconfig").rust_analyzer.setup({});
		require("lspconfig").pylsp.setup({
			settings = {
				pylsp = {
					plugins = {
						pycodestyle = {
							ignore = {'W391'},
							maxLineLength = 100
						}
					}
				}
			}
		});

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
				vim.lsp.buf.format()
			end
		})
	end
}
