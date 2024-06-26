require("custom_keymaps")

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 100
	end,
	config = function()
		require("which-key").setup();

		require("which-key").register({
			name = "Window",
			["<C-q>"] = {"<esc><c-o>:q<cr>", "Quit All"},
			["<C-t>"] = {"<cmd>enew<cr>", "New tab"},
			["<C-w>"] = {"<cmd>bdelete<cr>", "Close tab"},
			["<A-o>"] = {open_file, "Open file"},
			["<A-s>"] = {save_file, "Save file"},
			["<A-.>"] = {"<cmd>bnext<cr>", "Tab right"},
			["<A-,>"] = {"<cmd>bprevious<cr>", "Tab left"},
			mode = vim.g.allmodes,
		})

		require("which-key").register({
			name = "Editing keymaps",
			["<C-z>"] = {"<C-O>u", "Undo"},
			["<C-y>"] = {"<C-O><C-r>", "Redo"},
			["<C-d>"] = {"<cmd>stopinsert<cr>yyp<cmd>startinsert<cr>", "Copy line"},
			["<C-k>"] = {"<cmd>stopinsert<cr>dd<cmd>startinsert<cr>", "Delete line"},
			mode = vim.g.allmodes,
		})

		vim.keymap.set("", "<C-A>", "gggH<C-O>G", {noremap = true, desc = 'Select all'})
		vim.keymap.set("i", "<C-A>", "<C-O>gg<C-O>gH<C-O>G", {noremap = true, desc = 'Select all'})
		vim.keymap.set({"c", "o", "s"}, "<C-A>", "<C-C>gggH<C-O>G", {noremap = true, desc = 'Select all'})
		vim.keymap.set("x", "<C-A>", "<C-C>ggVG", {noremap = true, desc = 'Select all'})

		vim.keymap.set(vim.g.allmodes, "<C-e>", ":", {desc = 'cmdline', noremap = true})
		vim.keymap.set("i", "<C-e>", "<esc>:", {desc = 'cmdline', noremap = true})

		require("which-key").register({
			name = "Movement keymaps",

		})

		require("which-key").register({
			["<C-f>"] = {
				name = "Search functionalities",
				["f"] = {},
			},
			mode = { "n" }
		})

		require("which-key").register({
			["<leader>"] = {
				["f"] = {
					name = "Telescope",
					["f"] = { "<cmd>Telescope find_files<cr>", "Find File" },
					["b"] = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
					["g"] = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
					["c"] = { "<cmd>Huez<cr>", "Find Colorscheme" },
				},
			},
			mode = { "n" }
		})

		-- require("which-key").register({
		-- 	["<C-Up>"] = { "<cmd>move -2<cr>", "Move Line Up" },
		-- 	["<C-Down>"] = { "<cmd>move +1<cr>", "Move Line Down" },
		-- 	mode = { "i" }
		-- })

-- 		require("which-key").register({
-- 			["<C-Up>"] = { require("smart-splits").move_cursor_up, "Move Cursor Up" },
-- 			["<C-Down>"] = { require("smart-splits").move_cursor_down, "Move Cursor Down" },
-- 			["<C-Left>"] = { require("smart-splits").move_cursor_left, "Move Cursor Left" },
-- 			["<C-Right>"] = { require("smart-splits").move_cursor_right, "Move Cursor Right" },
--
-- 			["<A-Up>"] = { require("smart-splits").resize_up, "Resize Up" },
-- 			["<A-Down>"] = { require("smart-splits").resize_down, "Resize Down" },
-- 			["<A-Left>"] = { require("smart-splits").resize_left, "Resize Left" },
-- 			["<A-Right>"] = { require("smart-splits").resize_right, "Resize Right" },
--
-- 			["<C-S-Up>"] = { require("smart-splits").swap_buf_up, "Swap Buffer Up" },
-- 			["<C-S-Down>"] = { require("smart-splits").swap_buf_down, "Swap Buffer Down" },
-- 			["<C-S-Left>"] = { require("smart-splits").swap_buf_left, "Swap Buffer Left" },
-- 			["<C-S-Right>"] = { require("smart-splits").swap_buf_right, "Swap Buffer Right" },
--
-- 			["<C-\'>"] = { "<cmd> ToggleTerm direction=horizontal size=20 <cr>", "Terminal Horizontal" },
-- 			["<C-\">"] = { "<cmd> ToggleTerm direction=vertical size=60 <cr>", "Terminal Vertical" },
-- 			mode = { "n", "t" }
-- 		})
	end
}
