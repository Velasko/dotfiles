-- No need to copy this inside `setup()`. Will be used automatically.
return {
	'echasnovski/mini.nvim', 
	version = '*'
	-- Module mappings. Use `''` (empty string) to disable one.
	config=function()
		require('mini.move').setup({		
		mappings = {
			left = '<M-Left>',
			right = '<M-Right>',
			down = '<M-Down>',
			up = '<M-Up>',
		}})
	end
}
