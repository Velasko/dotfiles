require("custom_keymaps")

return {
	"folke/which-key.nvim",
	dependencies = { "echasnovski/mini.icons" },
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 100
	end,
	config = function()
		require("which-key").setup();

		require("which-key").register({
			name = "Window",
			["<C-q>"] = { "<esc><c-o>:q<cr>", "Quit All" },
			["<C-t>"] = { "<cmd>enew<cr>", "New tab" },
			["<C-w>"] = { "<cmd>bdelete<cr>", "Close tab" },
			["<A-o>"] = { open_file, "Open file" },
			["<A-s>"] = { save_file, "Save file" },
			["<A-.>"] = { "<cmd>bnext<cr>", "Tab right" },
			["<A-,>"] = { "<cmd>bprevious<cr>", "Tab left" },
			mode = vim.g.allmodes,
		})

		require("which-key").register({
			name = "Editing keymaps",
			["<C-z>"] = { "<C-O>u", "Undo" },
			["<C-y>"] = { "<C-O><C-r>", "Redo" },
			["<C-d>"] = { "<cmd>stopinsert<cr>yyp<cmd>startinsert<cr>", "Copy line" },
			["<C-k>"] = { "<cmd>stopinsert<cr>dd<cmd>startinsert<cr>", "Delete line" },
			["<C-_>"] = { CommentToggle, "Delete line" },
			mode = vim.g.allmodes,
		})

		vim.keymap.set("", "<C-A>", "gggH<C-O>G", { noremap = true, desc = 'Select all' })
		vim.keymap.set("i", "<C-A>", "<C-O>gg<C-O>gH<C-O>G", { noremap = true, desc = 'Select all' })
		vim.keymap.set({ "c", "o", "s" }, "<C-A>", "<C-C>gggH<C-O>G", { noremap = true, desc = 'Select all' })
		vim.keymap.set("x", "<C-A>", "<C-C>ggVG", { noremap = true, desc = 'Select all' })

		vim.keymap.set(vim.g.allmodes, "<C-e>", ":", { desc = 'cmdline', noremap = true })
		vim.keymap.set("i", "<C-e>", "<esc>:", { desc = 'cmdline', noremap = true })

		require("which-key").register({
			name = "Movement keymaps",
			["<C-Right>"] = { "<cmd>stopinsert<cr>E", "Go to next word" },
			["<C-Up>"] = { "<esc><cmd>'<, '> mo '<-2<cr><cmd>normal! gv<cr>", "Move block up" },
			["<C-Down>"] = { "<esc><cmd>'<, '> mo '>+1<cr><cmd>normal! gv<cr>", "Move block down" },
			["<Tab>"] = { ">gv", "Indent block" },
			["<S-Tab>"] = { "<gv", "Unndent block" },
			mode = { "v" }
		})

		require("which-key").register({
			name = "Movement keymaps",
			["<C-Left>"] = { "<cmd>stopinsert<cr>gea", "Go to previous word" },
			["<C-Up>"] = { "<cmd>stopinsert<cr>ddkPi", "Move line up" },
			["<C-Down>"] = { "<cmd>stopinsert<cr>ddjPi", "Move line down" },
			["<S-Tab>"] = { "<cmd><<cr>", "Unndent block" },
			mode = { "i", "n" }
		})

		-- 	["<C-f>"] = {
		-- 		name = "Search functionalities",
		-- 		["f"] = {},
		-- 	},
		-- 	mode = { "n" }
		-- })

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
	end
}
