return {
	"vague2k/huez.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"stevearc/dressing.nvim",
		-- themes
		"bluz71/vim-moonfly-colors",
	},
	config = function()
--		local colorscheme = require("huez.api").get_colorscheme()
--		vim.cmd("colorscheme " .. colorscheme);
		vim.cmd.colorscheme('moonfly')
		vim.keymap.set("n", "<leader>h", "<cmd>Huez<CR>", {desc = 'Huez menu'})
	end
}
