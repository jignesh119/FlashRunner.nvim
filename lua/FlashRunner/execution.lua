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
  local body=vim.split(codeblock.body,"\n")
  local output={"output"}


  Window.display_lines_in_floating_win({body=body,language=codeblock.language},output)
end

-- execute code 
-- @param codeblock: {code:string, lang:string}
M.execute_js_code=function(codeblock)
  -- prepare the boilerplate code
  -- compile and handle error and create output 
  local tempfile=vim.fn.tempname()
  local body=vim.split(codeblock.body,"\n")
  vim.fn.writefile(body,tempfile)

  -- local output="running..."
  -- local on_exit=function(obj)
  --   if(obj.stderr) then
  --     output=obj.stderr
  --   else
  --     output=obj.stdout
  --   end
  -- end
  local result=vim.system({"node",tempfile},{text=true}):wait()
  local output

  if(result.stderr) then
    output=vim.split(result.stderr,"\n")
  else
    output=result.stdout
  end

  Window.display_lines_in_floating_win({body=body,language=codeblock.language},output)
end

return M
