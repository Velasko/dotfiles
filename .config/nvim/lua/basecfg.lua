-- ref: https://github.com/vim/vim/blob/314dd79cac2adc10304212d1980d23ecf6782cfc/runtime/evim.vim
-- ref: https://github.com/neovim/neovim/blob/master/runtime/mswin.vim

local allmodes = {"", "i", "v", "c", "o"}

vim.opt.autoindent = true
vim.opt.shiftwidth = 4

-- confirmation on exit
vim.opt.confirm = true

vim.opt.spell = true
vim.opt.spelllang = "en_us,pt_br"

-- select text when holding shift
vim.opt.keymodel = "startsel,stopsel"
vim.opt.mouse = "a"
vim.opt.linebreak = true
vim.opt.lisp = true

-- cusor positional data
vim.opt.number = true
vim.opt.ruler = true

-- backspace and cursor keys wrap to previous/next line
vim.opt.backspace = "indent,eol,start"
vim.opt.whichwrap = vim.opt.whichwrap + "<,>,[,]"
vim.keymap.set(allmodes, '<A-BS>', '<C-W>', { noremap = true, desc = 'Delete word'})

-- backspace in Visual mode deletes selection
vim.keymap.set("v", "<BS>", "d", {noremap = true, desc = 'Delete selection'})

-- ctrl + q = quit
vim.keymap.set(allmodes, "<c-q>", "<esc><c-o>:q<cr>", {desc = 'Quit'})

-- vim.opt.clipboard = "xclip"
vim.opt.clipboard = "unnamedplus"
vim.keymap.set("v", "<C-X>", "<cmd>normal! x<cr>") -- cut
vim.keymap.set("v", "<C-C>", "<cmd>normal! y<cr>") -- copy
vim.keymap.set(allmodes, "<C-v>", "<cmd>normal! P<cr><Right>") -- paste

-- CTRL-T is new tab
vim.keymap.set(allmodes, "<C-T>", "<cmd>enew<cr>", {desc = 'New tab'})
-- CTRL-W is close tab
vim.keymap.set(allmodes, "<C-W>", "<cmd>bdelete<cr>", {desc = 'Close tab'})
-- Alt-O is open tab
vim.keymap.set(allmodes, "<A-o>", function()
		local input = vim.fn.input("Open file: ")
		vim.cmd.edit(input)
	end, {desc = 'Open file'}
)
-- ALT-. is right tab
vim.keymap.set(allmodes, "<A-.>", "<cmd>bnext<cr>", {desc = 'Tab right'})
-- ALT-, is right tab
vim.keymap.set(allmodes, "<A-,>", "<cmd>bprevious<cr>", {desc = 'Tab left'})

-- tab is indent
vim.keymap.set("v", "<Tab>", ">gv", {desc = 'Indent'})
vim.keymap.set("v", "<S-Tab>", "<gv", {desc = 'Unindent'})
vim.keymap.set("i", "<S-Tab>", "<cmd><<cr>", {desc = 'Unindent'})

-- Undo and Redo
vim.keymap.set(allmodes, "<C-Z>", "<C-O>u", {desc = 'Undo'})
vim.keymap.set(allmodes, "<C-Y>", "<C-O><C-R>", {desc = 'Redo'})

-- CTRL-A is Select all
vim.keymap.set("", "<C-A>", "gggH<C-O>G", {noremap = true, desc = 'Select all'})
vim.keymap.set("i", "<C-A>", "<C-O>gg<C-O>gH<C-O>G", {noremap = true, desc = 'Select all'})
vim.keymap.set({"c", "o", "s"}, "<C-A>", "<C-C>gggH<C-O>G", {noremap = true, desc = 'Select all'})
vim.keymap.set("x", "<C-A>", "<C-C>ggVG", {noremap = true, desc = 'Select all'})

vim.keymap.set(allmodes, "<C-e>", ":", {desc = 'cmdline'})
vim.keymap.set("i", "<C-e>", "<esc>:", {desc = 'cmdline'})

-- CTRL-L is the goto line dialog
vim.keymap.set("i", "<C-L>",
	function()
		local input = vim.fn.input("Go to line: ")
		return "<cmd>:" .. input .. "<CR>"
	end,
	{expr = true, noremap = true, desc = 'Go to line'}
)

-- Use CTRL-S for saving, also in Insert mode
vim.keymap.set(allmodes, "<C-s>",
	function()
		local filename = vim.api.nvim_buf_get_name(0)
		vim.cmd.write(filename ~= "" and filename or vim.fn.input("File name: "))
	end, {desc = 'Save'}
)

vim.keymap.set(allmodes, "<M-S>",
	function()
		vim.cmd.write(vim.fn.input("File name: "))
	end, {desc = 'Save as'}
)

local function sanitize_string(s)
	local dirty_string = string.gsub(s, "[&/\\]", "\\%1")
	for _, char in ipairs({	{"\a", "\\a"},
							{"\b", "\\b"},
							{"\f", "\\f"},
							{"\n", "\\n"},
							{"\r", "\\r"},
							{"\t", "\\t"},
							{"\v", "\\v"},
							{"\"", "\\\""},
							{"\''", "\\'"}, }) do
		dirty_string = string.gsub(dirty_string, char[1], char[2])
	end
	return dirty_string
end

local function get_visual_selection()
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
	return sanitize_string(get_visual_selection())
end
vim.keymap.set(allmodes, "<C-h>", get_selection)
-- vim.api.nvim_create_autocmd("get_selection", {callback = function() vim.notify("called back") end})

-- Use Ctrl-f to find
vim.keymap.set(allmodes, "<C-f>",
	function()
		local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
		local search_cmd = "/"

		if get_mode() == "i" then
			-- go to normal mode
			vim.api.nvim_feedkeys(esc, 'x', false)
		elseif get_mode() == "v" then
			-- go to normal mode
			vim.api.nvim_feedkeys(esc, 'x', false)
			search_cmd = search_cmd .. get_selection()
		end

		vim.api.nvim_feedkeys(search_cmd, 'tn', true)
	end,
	{desc = 'Find in file', remap = true}
)

-- Use Ctrl-R to replace
function prompt_callback(func)
	vim.api.nvim_create_autocmd("CmdlineLeave", {
		once = true,
		callback =	func
	})
end

vim.keymap.set(allmodes, "<C-r>",
	function()
		local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
		local search_cmd = ":%s/"

		if get_mode() == "i" then
			-- go to normal mode
			vim.api.nvim_feedkeys(esc, 'x', false)
		elseif get_mode() == "v" then
			-- go to normal mode
			vim.api.nvim_feedkeys(esc, 'x', false)
			search_cmd = search_cmd .. get_selection()
		end

		vim.api.nvim_feedkeys(search_cmd, 'tn', true)
		prompt_callback(get_new_string)

	end,
	{desc = 'Replace', remap = true}
)

function get_new_string(event)
	-- event.abort = true
	vim.api.nvim_feedkeys("/2", 'tn', true)
	prompt_callback(finish_replace)
end

function finish_replace()
	vim.event = abort
	vim.api.nvim_feedkeys("/g", 'tn', true)
end

-- clear highlight
vim.keymap.set("i", "<Esc>", "<Esc>", {desc = 'Clear', noremap = true})
vim.keymap.set({"", "v"}, "<Esc>", "<Esc><cmd>:noh<cr><cmd>startinsert<cr>", {desc = 'Clear', noremap = true})
-- ref: https://neovim.io/doc/user/autocmd.html#autocmd-events
-- ref: https://neovim.io/doc/user/api.html#nvim_create_autocmd
vim.api.nvim_create_autocmd("CmdlineEnter", {callback = function() vim.cmd("startinsert") end})
vim.cmd("startinsert")
