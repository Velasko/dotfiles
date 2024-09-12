return {
	"vague2k/huez.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"stevearc/dressing.nvim",
		-- themes
		"bluz71/vim-moonfly-colors",
		"RRethy/base16-nvim",
	},
	config = function()
		require("huez").setup({})
		require('base16-colorscheme').with_config({
			indentblankline = true,
			illuminate = true,
			ts_rainbow = true,
			telescope = true,
			notify = true,
			dapui = true,
			cmp = true,
		})

		vim.cmd.colorscheme('base16-' .. os.getenv('BASE16_THEME'))
		vim.keymap.set("n", "<leader>h", "<cmd>Huez<CR>", { desc = 'Huez menu' })
	end
}
