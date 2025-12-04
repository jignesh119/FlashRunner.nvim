local M = {}

local ExecutionEngine=require("FlashRunner.execution")

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
  local ft=vim.bo.filetype
  local language=ft

 -- trim first and last lines to the selected columns
  if #lines > 0 then
    lines[1] = string.sub(lines[1], cs, #lines[1])
    lines[#lines] = string.sub(lines[#lines], 1, ce)
  end

--  print("selected lines ",vim.inspect(lines),ls,le)

  --M.notify(lines,ls,le)
  local executor=nil
  local codeblock={body=table.concat(lines,"\n").. "\n",language=language}

  -- lua, python, php, cpp, rust, go, typescript
  if language== "cpp" then
    executor=ExecutionEngine.execute_cpp_code
  elseif language=="javascript" then
      executor=ExecutionEngine.execute_js_code
  end

  if not executor then
    print("No valid executor for this language: ",language)
  else
    executor(codeblock)
  end

end




return M
