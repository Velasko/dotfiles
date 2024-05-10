local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
vim.opt.termguicolors = true
allmodes = {"", "i", "v", "c", "o"}

require("lazy").setup({
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
  {"nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "3rd/image.nvim"}},
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  {'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }},
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"lewis6991/gitsigns.nvim"},
  {'nvim-telescope/telescope.nvim', tag = '0.1.6', dependencies = { 'nvim-lua/plenary.nvim' }},
  {"bluz71/vim-moonfly-colors"},
  {"vague2k/huez.nvim", dependencies = { "nvim-telescope/telescope.nvim", "stevearc/dressing.nvim" }},
  {"VonHeikemen/lsp-zero.nvim", dependencies = {"neovim/nvim-lspconfig", "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim"}},
  {"hrsh7th/nvim-cmp", dependencies = { 'L3MON4D3/LuaSnip', "hrsh7th/cmp-nvim-lsp"}},
  {"rcarriga/nvim-notify"},
  {"folke/noice.nvim", event = "VeryLazy", dependencies = {"MunifTanjim/nui.nvim"}},
  {"luckasRanarison/nvim-devdocs", dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "nvim-treesitter/nvim-treesitter"}, opts = {}},
})

vim.notify = require("notify")
vim.notify.setup {
  stages = 'slide',
  background_colour = 'FloatShadow',
  timeout = 3000,
  level = TRACE,
  fps = 144
}

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.notify(" File: " .. vim.fn.expand("%"), "info", {
      title = " File Saved",
      timeout = 500,
      stages = 'fade_in_slide_out',
      background_colour = 'FloatShadow',
    });
  end
})

require("basecfg")

require("neo-tree").setup {
  enable_git_status = false,
  event_handlers = { {
  event = "file_opened",
  handler = function()
    require("neo-tree.command").execute({ action = "close" })
  end
}}};
vim.keymap.set(allmodes, "<A-f>", "<cmd>Neotree toggle<cr>", { noremap = false, desc = 'File tree' });

require("bufferline").setup{options = {offsets = {{
    filetype = "neo-tree",
    text = "Nvim Tree",
    separator = true,
    text_align = "center"
}}}}

require("nvim-treesitter.configs").setup {
  ensure_installed = { "html", "rust", "python" },
  sync_install = true,
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
}

require("ibl").setup()

require('lualine').setup {options = {
  globalstatus = true,
  theme = 'gruvbox',
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
}}

require('gitsigns').setup {
  sign_priority = 0,
  current_line_blame = true,
}

local colorscheme = require("huez.api").get_colorscheme()
vim.cmd("colorscheme " .. colorscheme)
vim.cmd.colorscheme('moonfly')
vim.keymap.set("n", "<leader>h", "<cmd>Huez<CR>", {desc = 'Huez menu'})

require("telescope.builtin")
vim.keymap.set(allmodes, "<C-o>", "<cmd>Telescope find_files<cr>", { remap = true, desc = 'Fuzzy open file'})
vim.keymap.set(allmodes, "<AS-F>", "<cmd>Telescope live_grep<cr>", { remap = true, desc = 'Fuzzy search in file'})
vim.keymap.set(allmodes, "<C-b>", "<cmd>Telescope buffers<cr>", { remap = true, desc = 'Fuzzy tab focus'})

local lsp = require('lsp-zero')
lsp.on_attach(function(_client, buffer)
  lsp.default_keymaps({ buffer })
end);

require("mason").setup()
require("mason-lspconfig").setup({handlers = {
  function(server)
    require('lspconfig')[server].setup({});
  end,
}})

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
  if vim.lsp.buf.server_ready() then
    vim.lsp.buf.format()
  end
end
})

local cmp = require('cmp')
cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	performance = {
		max_view_entries = 10
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'vsnip' },
		{ name = 'path' },
	})
})

require("noice").setup({
    lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

require("nvim-devdocs").setup()
