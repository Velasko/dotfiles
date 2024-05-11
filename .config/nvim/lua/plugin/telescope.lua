return {
	'nvim-telescope/telescope.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	opts = {
		extensions = {
			file_browser = { layout_strategy = "horizontal", sorting_strategy = "ascending" },
			heading = { treesitter = true },
			["ui-select"] = { require("telescope.themes").get_dropdown({}) }
		},
		defaults = {
			file_ignore_patterns = { "node_modules", "target", ".git", "Cargo.lock" },
			layout_strategy = "vertical",
			layout_config = {
				vertical = {
					width = 0.9,
					height = 0.9,
					preview_height = 0.6,
					preview_cutoff = 0
				}
			},
		}
	},
	config = function()
		local builtin = require("telescope.builtin")
		require("telescope").load_extension("noice")
		vim.keymap.set(vim.g.allmodes, "<C-o>", "<cmd>Telescope find_files<cr>", { remap = true, desc = 'Fuzzy open file'})
		vim.keymap.set(vim.g.allmodes, "<AS-F>", "<cmd>Telescope live_grep<cr>", { remap = true, desc = 'Fuzzy search in file'})
		vim.keymap.set(vim.g.allmodes, "<C-b>", "<cmd>Telescope buffers<cr>", { remap = true, desc = 'Fuzzy tab focus'})

	end
}
