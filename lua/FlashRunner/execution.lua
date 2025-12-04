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
M.create_system_executor=function(program)
return function(codeblock)
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
  local result=vim.system({program,tempfile},{text=true}):wait()
  local output
  -- print(vim.inspect(result))

  if(result.stderr ~= "") then
    output=vim.split(result.stderr,"\n")
  else
    output=vim.split(result.stdout,"\n")  end

  Window.display_lines_in_floating_win({body=body,language=codeblock.language},output)
end
end


M.execute_javascript_code=M.create_system_executor("node")
M.execute_python_code=M.create_system_executor("python")
-- M.execute_typescript_code=M.create_system_executor("ts-node")

return M
