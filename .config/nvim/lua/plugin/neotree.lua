return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim",
	},
	config = function()
		require("neo-tree").setup {
			sort_function = function(a, b)
				if a.type == b.type then
					if a.ext == b.ext then
						if a.name == "mod.rs" then return false end
						if b.name == "mod.rs" then return true end
						return a.path < b.path
					end

					if a.ext == nil then return false end
					if b.ext == nil then return true end

					return a.name < b.name
				else
					return a.type < b.type
				end
			end,
			filesystem = {
				filtered_items = {
					hide_by_name = {
						"node_modules",
						"Cargo.lock",
						"target",
					}
				}
			},
			enable_git_status = false,
			event_handlers = { {
				event = "file_opened",
				handler = function()
					require("neo-tree.command").execute({ action = "close" })
				end
			} },
		};
		vim.keymap.set({ "n" }, "<A-f>", "<cmd>Neotree toggle<cr>", { remap = false, silent = true });
	end
}
