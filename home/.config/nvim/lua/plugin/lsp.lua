return {
	"neovim/nvim-lspconfig",
	config = function()
		vim.diagnostic.config({
			virtual_text = true,
			underline = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "!",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "󰙎",
					[vim.diagnostic.severity.HINT] = "󰉀",
				}
			}
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("Lspconfig", { clear = true }),
			callback = function(args) end
		})

		vim.lsp.enable({ "rust_analyzer", "lua_ls", "taplo", "yamlls", "ruff", "jedi_language_server" })
	end
}
