local M = {}

local Window=require("FlashRunner.window")

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
  Window.display_lines_in_floating_win(lines)
end




return M
