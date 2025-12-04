local M={}

-- @param codeblock: {body:string,language:string}
function M.display_lines_in_floating_win(codeblock,output)
  local cb={}
  cb.language=codeblock.language or "cpp"
  cb.body=codeblock.body or 'cout<<"hello world\n"'

  -- Create window.
  local width = math.ceil(vim.o.columns * 0.6)
  local height = math.ceil(vim.o.lines * 0.7)
  local buf = vim.api.nvim_create_buf(false, true)

  local content={"","#Code", "","```" ..codeblock.language}
  -- vim.list_extend(content,vim.split(codeblock.body,"\n"))
  vim.list_extend(content,codeblock.body)
  table.insert(content,"```")

  table.insert(content,"".."#Output")
  table.insert(content,output)

  vim.api.nvim_buf_set_lines(buf, 0, 500, false, content)

  local float = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    style = 'minimal',
    width = width,
    height = height,
    col = math.ceil((vim.o.columns - width) / 2),
    row = math.ceil((vim.o.lines - height) / 2 - 1),
    border = 'rounded'
  })

  vim.keymap.set("n","q",function()
    vim.api.nvim_win_close(float,true)
  end)

end

return M
