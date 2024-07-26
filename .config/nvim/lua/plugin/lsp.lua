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

		-- rust
		require("lspconfig").rust_analyzer.setup({});

		-- python
		require("lspconfig").ruff.setup({})
		require("lspconfig").jedi_language_server.setup({
			single_file_support = false
		})

		-- lua
		require'lspconfig'.lua_ls.setup({})

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
