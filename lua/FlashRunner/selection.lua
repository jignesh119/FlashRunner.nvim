local M = {}

local ExecutionEngine=require("FlashRunner.execution")

M.notify=function(lines,ls,le)
  print(vim.inspect(lines))
end

-- get selected lines or full buffer content 
M.get_selection=function ()
  local mode=vim.api.nvim_get_mode()
  if mode== 'v' or mode=='V' or mode =="\22" then
    local srow=vim.api.nvim_buf_get_mark(0,'<')[1]
    local scol=vim.api.nvim_buf_get_mark(0,'<')[2]
    local erow=vim.api.nvim_buf_get_mark(0,'>')[1]
    local ecol=vim.api.nvim_buf_get_mark(0,'>')[2]
    local lines=vim.api.nvim_buf_get_lines(0,srow-1,erow,false)
    return table.concat(lines,"\n")
  else
    return table.concat(vim.api.nvim_buf_get_lines(0,0,-1,false),"\n")
  end
end

M.get_visual_selection=function()
  -- local _, ls, cs = unpack(vim.fn.getpos("'<"))
  -- local _, le, ce = unpack(vim.fn.getpos("'>"))
  -- local config={} --soem config to send like lang,etc
 -- normalize (in case user selected backwards)
  -- if ls > le then
  --   ls, le = le, ls
  --   cs, ce = ce, cs
  -- end
  -- local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)

  local lines = M.get_selection()
  local ft=vim.bo.filetype
  local language=ft

 -- trim first and last lines to the selected columns
  -- if #lines > 0 then
  --   lines[1] = string.sub(lines[1], cs, #lines[1])
  --   lines[#lines] = string.sub(lines[#lines], 1, ce)
  -- end
--  print("selected lines ",vim.inspect(lines),ls,le)

  --M.notify(lines,ls,le)
  local executor=nil
  -- local codeblock={body=table.concat(lines,"\n").. "\n",language=language}
  local codeblock={body=lines,language=language}

  --TODO: lua, php, rust, go
  if language== "cpp" then
    executor=ExecutionEngine.execute_cpp_code
  elseif language=="javascript" then
      executor=ExecutionEngine.execute_javascript_code
  elseif language=="python" then
    executor=ExecutionEngine.execute_python_code
  -- elseif language=="typescript" then
  --   executor=ExecutionEngine.execute_typescript_code
  end

  if not executor then
    print("No valid executor for this language: ",language)
  else
    executor(codeblock)
  end

end




return M
