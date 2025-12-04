local M={}
local Selection=require("FlashRunner.selection")

-- M.options ={}

M.hello_world = function()
	print("Hello! welcome to FlashRunner!!")
end

M.setup = function(opts)
	opts = opts or {}
  -- opts.executors=opts.executors or {}
  -- opts.executors["cpp"]=opts.executors["cpp"] or 
  --
  -- M.options=opts


	-- Create the user command 
    -- NOTE: user commands start with capital letters
	vim.api.nvim_create_user_command("FlashRunner", M.hello_world, {})
	vim.api.nvim_create_user_command("Frshow", Selection.get_visual_selection, {})

	-- Use opts.keymap if provided, otherwise default to '<leader>Fr'
	local keymap = opts.keymap or "<leader>Frh"

	-- keymap
	vim.keymap.set("n", keymap, M.hello_world, {
		desc = "Say hello from FlashRunner",
		silent = true,
	})

    vim.keymap.set("v", "<leader>Frs", function()
        local lines = Selection.get_visual_selection()
    end, { silent = true })


end


return M
