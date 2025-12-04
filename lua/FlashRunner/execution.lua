local M={}
local Window=require("FlashRunner.window")

-- execute code 
-- @param codeblock: {code:string, lang:string}
M.execute_code=function(codeblock)

  local output={"","#Code", "","```",codeblock.language}
  vim.list_extend(output,vim.split(codeblock.body,"\n"))
  table.insert(output,"```")

end

-- execute code 
-- @param codeblock: {code:string, lang:string}
M.execute_cpp_code=function(codeblock)
  -- prepare the boilerplate code
  -- compile and handle error and create output 
  local output="output"
  Window.display_lines_in_floating_win(codeblock,output)
end

return M
