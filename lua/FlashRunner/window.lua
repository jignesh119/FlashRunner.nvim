local M={}

local function create_float(config, enter)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, enter or false, config)
  return { buf = buf, win = win }
end

-- background = 60% x 70%, header + body inside bg
local function create_layout()
  local total_w = vim.o.columns
  local total_h = vim.o.lines

  local bg_w = math.floor(total_w * 0.70)
  local bg_h = math.floor(total_h * 0.80)

  local x = math.floor((total_w - bg_w) / 2)
  local y = math.floor((total_h - bg_h) / 2)

  -- Header height
  local header_h = 3
  local body_h = bg_h - header_h

  return {
    background = {
      relative = "editor",
      width = bg_w,
      height = bg_h,
      style = "minimal",
      border = "rounded",
      col = x,
      row = y,
      zindex = 1,
    },
    header = {
      relative = "editor",
      width = bg_w - 2, -- inside border
      height = header_h,
      style = "minimal",
      border = "rounded",
      col = x + 1,
      row = y + 1,
      zindex = 2,
    },
    body = {
      relative = "editor",
      width = bg_w - 2,
      height = body_h - 2,
      style = "minimal",
      border = "rounded",
      col = x + 1,
      row = y + header_h + 1,
      zindex = 3,
    },
  }
end

-- @param codeblock: {body:string[],language:string}
-- @param output: string[] must not contain embeded "\n"
function M.display_lines_in_floating_win(codeblock,output)
  local cb={}
  cb.language=codeblock.language or "cpp"
  cb.body=codeblock.body or 'cout<<"hello world\n"'

  -- local width = math.ceil(vim.o.columns * 0.6)
  -- local height = math.ceil(vim.o.lines * 0.7)
  -- local buf = vim.api.nvim_create_buf(false, true)

  local content={"","# Code ", "","```" ..codeblock.language}
  -- vim.list_extend(content,vim.split(codeblock.body,"\n"))
  vim.list_extend(content,codeblock.body)
  table.insert(content,"```")

  table.insert(content,"")
  table.insert(content,"# Output")
  table.insert(content,"")
  vim.list_extend(content,output)
  -- table.insert(content,table.concat(output))

local layout=create_layout()

  --bg
  local bg=create_float(layout.background,false)
  vim.api.nvim_buf_set_lines(bg.buf,0,-1,false,{})
  vim.bo[bg.buf].filetype="markdown"

  --header
  local header=create_float(layout.header,false)
  vim.api.nvim_buf_set_lines(header.buf,0,-1,false,{
    "",
    "\t\t  FlashRunner - Code Execution Result ",
  })
  vim.bo[header.buf].filetype="markdown"

  --body
  local body=create_float(layout.body,true)
  vim.api.nvim_buf_set_lines(body.buf,0,-1,false,content)
  vim.bo[body.buf].filetype="markdown"


  -- local float = vim.api.nvim_open_win(buf, true, {
  --   relative = 'editor',
  --   style = 'minimal',
  --   width = width,
  --   height = height,
  --   col = math.ceil((vim.o.columns - width) / 2),
  --   row = math.ceil((vim.o.lines - height) / 2 - 1),
  --   border = 'rounded'
  -- })

  vim.keymap.set("n","q",function()
    -- vim.api.nvim_win_close(float,true)
    pcall(vim.api.nvim_win_close,bg.win,true)
    pcall(vim.api.nvim_win_close,header.win,true)
    pcall(vim.api.nvim_win_close,body.win,true)
  end,{buffer=body.buf})

end

return M
