local M={}

function M.display_lines_in_floating_win(lines)
  -- Create window.
  local width = math.ceil(vim.o.columns * 0.6)
  local height = math.ceil(vim.o.lines * 0.7)
  local buf = vim.api.nvim_create_buf(false, true)


  local float = vim.api.nvim_open_win(buf, true, {
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
  -- vim.api.nvim_buf_add_highlight(buf, namespace_id, hl, h,0,-1) -- highlight lines in floating window
  vim.keymap.set("n","q",function()
    vim.api.nvim_win_close(float,true)
  end)

end

return M
