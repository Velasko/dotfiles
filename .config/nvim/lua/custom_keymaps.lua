-- ref: https://github.com/vim/vim/blob/314dd79cac2adc10304212d1980d23ecf6782cfc/runtime/evim.vim
-- ref: https://github.com/neovim/neovim/blob/master/runtime/mswin.vim

local allmodes = { "", "i", "v", "c", "o" }

vim.opt.autoindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- confirmation on exit
vim.opt.confirm = true

vim.opt.spell = true
vim.opt.spelllang = "en_us,pt_br"

-- select text when holding shift
vim.opt.keymodel = "startsel,stopsel"
vim.opt.mouse = "a"
-- vim.keymap.set("v", "<C-S-Right>", "E")

vim.opt.linebreak = true
vim.opt.lisp = true

-- cusor positional data
vim.opt.number = true
vim.opt.ruler = true

-- backspace and cursor keys wrap to previous/next line
vim.opt.backspace = "indent,eol,start"
vim.opt.whichwrap = vim.opt.whichwrap + "<,>,[,]"
vim.keymap.set(allmodes, '<A-BS>', '<C-W>', { noremap = true, desc = 'Delete word' })

-- backspace in Visual mode deletes selection
vim.keymap.set("v", "<BS>", "d", { noremap = true, desc = 'Delete selection' })

-- ctrl + q = quit
--vim.keymap.set(allmodes, "<c-q>", "<esc><c-o>:q<cr>", {desc = 'Quit', noremap = true})

-- vim.opt.clipboard = "xclip"
vim.opt.clipboard = "unnamedplus"
vim.keymap.set("v", "<C-X>", "<cmd>normal! x<cr>", { desc = 'Cut' })                                             -- cut
vim.keymap.set("v", "<C-C>", "<cmd>normal! y<cr>", { desc = 'Copy' })                                            -- copy
vim.keymap.set(allmodes, "<C-v>", "<cmd>normal! P<cr><cmd>startinsert!<cr>", { noremap = true, desc = 'Paste' }) -- paste
--vim.keymap.set(allmodes, "<A-v>", "<cmd>normal! <C-W>P<cr><Right>", {desc = 'Paste Replace'}) -- paste replace

function open_file()
	local input = vim.fn.input("Open file: ")
	if input ~= "" then
		vim.cmd.edit(input)
	end
end

-- ALT-. is right tab
--vim.keymap.set(allmodes, "<A-.>", "<cmd>bnext<cr>", {desc = 'Tab right'})
-- ALT-, is right tab
--vim.keymap.set(allmodes, "<A-,>", "<cmd>bprevious<cr>", {desc = 'Tab left'})

-- tab is indent
-- vim.keymap.set("v", "<Tab>", ">gv", { desc = 'Indent' })
-- vim.keymap.set("v", "<S-Tab>", "<gv", { desc = 'Unindent' })
-- vim.keymap.set("i", "<S-Tab>", "<cmd><<cr>", { desc = 'Unindent' })

-- Undo and Redo
-- vim.keymap.set(allmodes, "<C-Z>", "<C-O>u", {desc = 'Undo'})
-- vim.keymap.set(allmodes, "<C-Y>", "<C-O><C-R>", {desc = 'Redo'})

-- Comment toggle function

function CommentToggle()
	if get_mode() == "v" then
		local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
		vim.api.nvim_feedkeys(esc, 'x', false)
		vim.cmd("'<, '>CommentToggle")
	else
		vim.cmd("CommentToggle")
	end
end

-- CTRL-A is Select all
vim.keymap.set("", "<C-A>", "gggH<C-O>G", { noremap = true, desc = 'Select all' })
vim.keymap.set("i", "<C-A>", "<C-O>gg<C-O>gH<C-O>G", { noremap = true, desc = 'Select all' })
vim.keymap.set({ "c", "o", "s" }, "<C-A>", "<C-C>gggH<C-O>G", { noremap = true, desc = 'Select all' })
vim.keymap.set("x", "<C-A>", "<C-C>ggVG", { noremap = true, desc = 'Select all' })

vim.keymap.set(allmodes, "<C-e>", ":", { desc = 'cmdline', noremap = true })
vim.keymap.set("i", "<C-e>", "<esc>:", { desc = 'cmdline', noremap = true })

-- CTRL-L is the "goto line" dialog
function goto_line()
	vim.cmd("stopinsert")
	vim.api.nvim_feedkeys(":", 'tn', true)
end

vim.keymap.set("i", "<C-L>",
	function()
		vim.cmd("stopinsert")
		vim.api.nvim_feedkeys(":", 'tn', true)
	end,
	{ expr = true, noremap = true, desc = 'Go to line' }
)

-- Use CTRL-S for saving, also in Insert mode
function save_file()
	local filename = vim.api.nvim_buf_get_name(0)
	vim.cmd.write(filename ~= "" and filename or vim.fn.input("File name: "))
end

vim.keymap.set(allmodes, "<C-s>",
	save_file, { desc = 'Save' }
)

vim.keymap.set(allmodes, "<M-S>",
	function()
		vim.cmd.write(vim.fn.input("File name: "))
	end, { desc = 'Save as' }
)

function sanitize_string(s)
	local dirty_string = string.gsub(s, "[&/\\]", "\\%1")
	for _, char in ipairs({ { "\a", "\\a" },
		{ "\b",  "\\b" },
		{ "\f",  "\\f" },
		{ "\n",  "\\n" },
		{ "\r",  "\\r" },
		{ "\t",  "\\t" },
		{ "\v",  "\\v" },
		{ "\"",  "\\\"" },
		{ "\''", "\\'" }, }) do
		dirty_string = string.gsub(dirty_string, char[1], char[2])
	end
	return dirty_string
end

function get_visual_selection()
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local n_lines = math.abs(s_end[2] - s_start[2]) + 1
	local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
	lines[1] = string.sub(lines[1], s_start[3], -1)
	if n_lines == 1 then
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
	else
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
	end
	return table.concat(lines, '\n')
end

function get_mode()
	return vim.fn.mode()
end

function get_selection()
	if get_mode() == "v" then
		local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
		vim.api.nvim_feedkeys(esc, 'x', false)
	end
	return sanitize_string(get_visual_selection())
end

vim.keymap.set(allmodes, "<C-h>", get_selection)

-- Use Ctrl-f to find
vim.keymap.set(allmodes, "<C-f>",
	function()
		local search_cmd = "/"

		vim.cmd("stopinsert")
		if get_mode() == "v" then
			search_cmd = search_cmd .. get_selection()
		end

		vim.api.nvim_feedkeys(search_cmd, 'tn', true)
	end,
	{ desc = 'Find in file', remap = true }
)

-- Use Ctrl-R to replace
function prompt_callback(func)
	vim.api.nvim_create_autocmd("CmdlineLeave", {
		once = true,
		callback = func
	})
end

vim.keymap.set(allmodes, "<C-r>",
	function()
		local search_cmd = ":%s/"

		vim.cmd("stopinsert")
		if get_mode() == "v" then
			earch_cmd = search_cmd .. get_selection()
		end

		vim.api.nvim_feedkeys(search_cmd, 'tn', true)

		--		prompt_callback(finish_replace)
	end,
	{ desc = 'Replace', remap = true }
)

function finish_replace(event)
	vim.api.nvim_feedkeys("/2", 'tn', true)
end

-- clear highlight
vim.keymap.set("i", "<Esc>", "<Esc>", { desc = 'Clear', noremap = true })
vim.keymap.set({ "", "v" }, "<Esc>", "<Esc><cmd>:noh<cr>a", { desc = 'Clear', noremap = true })
-- ref: https://neovim.io/doc/user/autocmd.html#autocmd-events
-- ref: https://neovim.io/doc/user/api.html#nvim_create_autocmd
vim.api.nvim_create_autocmd("CmdlineEnter", { callback = function() vim.cmd("startinsert!") end })
vim.cmd("startinsert")
