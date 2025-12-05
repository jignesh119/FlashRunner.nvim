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


    -- NOTE: user commands start with capital letters

  -- lets restrict users to use our default user_command
	vim.api.nvim_create_user_command("FlashRunnerShow", Selection.get_visual_selection, {})

	-- Use opts.keymap if provided, otherwise default to '<leader>Frs'
	local keymap = opts.keymap or "<leader>Fr"

	-- keymap
	-- vim.keymap.set("n", keymap, M.hello_world, {
	-- 	desc = "Say hello from FlashRunner",
	-- 	silent = true,
	-- })

  vim.keymap.set("v", keymap,Selection.get_visual_selection, {
    desc="Execute the code block under the selection, or the entire buffer if no selection is active.",
    silent=true
  })


end


return M
