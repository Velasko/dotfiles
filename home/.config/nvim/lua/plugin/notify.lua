-- notification system

return {
	"rcarriga/nvim-notify",
	priority = 0,
	config = function()
		vim.notify = require("notify")
		vim.notify.setup {
			stages = 'slide',
			background_colour = 'FloatShadow',
			timeout = 3000,
			level = TRACE,
			fps = 144
		}
	end
}
