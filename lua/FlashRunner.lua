local M = {}

M.hello_world = function()
	print("Hello! welcome to FlashRunner!!")
end

M.setup = function(opts)
	opts = opts or {}
	-- Create the user command
	vim.api.nvim_create_user_command("FlashRunner", M.hello_world, {})

	-- Use opts.keymap if provided, otherwise default to '<leader>Fr'
	local keymap = opts.keymap or "<leader>Fr"

	-- keymap
	vim.keymap.set("n", keymap, M.hello_world, {
		desc = "Say hello from FlashRunner",
		silent = true,
	})
end

return M
