local M = {}

M.hello_world = function()
	print("Hello! welcome to FlashRunner!!")
end

M.notify=function(lines,ls,le)
  print(vim.inspect(lines))
end

M.get_visual_selection=function()
    -- starting , ending points 
  local _, ls, cs = unpack(vim.fn.getpos("'<"))
  local _, le, ce = unpack(vim.fn.getpos("'>"))

 -- normalize (in case user selected backwards)
  if ls > le then
    ls, le = le, ls
    cs, ce = ce, cs
  end

-- fetch the lines
  local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)

 -- trim first and last lines to the selected columns
  if #lines > 0 then
    lines[1] = string.sub(lines[1], cs, #lines[1])
    lines[#lines] = string.sub(lines[#lines], 1, ce)
  end

--  print("selected lines ",vim.inspect(lines),ls,le)

  M.notify(lines,ls,le)
end


M.setup = function(opts)
	opts = opts or {}
	-- Create the user command 
    -- NOTE: user commands start with capital letters
	vim.api.nvim_create_user_command("FlashRunner", M.hello_world, {})
	vim.api.nvim_create_user_command("Frshow", M.get_visual_selection, {})

	-- Use opts.keymap if provided, otherwise default to '<leader>Fr'
	local keymap = opts.keymap or "<leader>Frh"

	-- keymap
	vim.keymap.set("n", keymap, M.hello_world, {
		desc = "Say hello from FlashRunner",
		silent = true,
	})

    vim.keymap.set("v", "<leader>Frs", function()
        local lines = M.get_visual_selection()
    end, { silent = true })


end



return M
