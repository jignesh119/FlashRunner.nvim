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

  local config={} --soem config to send like lang,etc

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

  --M.notify(lines,ls,le)
  M.display_lines_in_floating_win(lines)
end

function M.display_lines_in_floating_win(lines)
    -- Create window.
    local width = math.ceil(vim.o.columns * 0.6)
    local height = math.ceil(vim.o.lines * 0.7)
    local buf = vim.api.nvim_create_buf(false, true)


    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        style = 'minimal',
        width = width,
        height = height,
        col = math.ceil((vim.o.columns - width) / 2),
        row = math.ceil((vim.o.lines - height) / 2 - 1),
        border = 'single'
    })
    -- vim.api.nvim_win_set_option(M.info_floatwin.win, 'winhighlight', 'Normal:CursorLine')

    -- local namespace_id = vim.api.nvim_create_namespace("sniprun_info")
    vim.api.nvim_buf_set_lines(buf, 0, 500, false, lines)
    -- vim.api.nvim_buf_add_highlight(M.info_floatwin.buf, namespace_id, hl, h,0,-1) -- highlight lines in floating window
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
