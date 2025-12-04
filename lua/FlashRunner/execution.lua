local M={}
local Window=require("FlashRunner.window")
local Utils=require("FlashRunner.util")

local CLING_RUNNER=vim.g.cling_runner_path or "./cling-runner.sh"
local TIMEOUT_MS=vim.g.cling_runner_timeout_ms or 8000

-- execute code 
-- @param codeblock: {code:string, lang:string}
M.execute_cpp_code=function(codeblock)
  --TODO:
  --build a temporary file and compile it and record output
  --STEPS: add boilerplate -> build -> execute 
  --various nuances in this task,
  --check if int main() is found in snippet
  --handle preprocessor directives at top, header includes
  --namespaces,
  -- vim.fn.jobstart({"g++","main.cpp","-o q","./q"},{
  --   stdout_buffered=true,
  --   on_stdout=function(_,data)
  --     if data then
  --       print(data)
  --     end
  --   end,
  --   on_stderr=function(_,data)
  --     if data then
  --       print(data)
  --     end
  --   end
  -- })
  --HACK: lets use cling interpreter and life's simple again

  local tmp=Utils.make_tempfile()
  local f=io.open(tmp,'w')
  f:write(codeblock.body)
  f:close()

  local body=vim.split(codeblock.body,"\n")
  local combined,output={},{}

  local function on_exit(code,signal)
    local comb={}
    table.insert(comb,tostring(code))
    vim.list_extend(comb,combined)
    -- table.insert(combined,stdout)
    -- table.insert(combined,stderr)
    local ec,stdout_lines,stderr_lines=Utils.parse_runner_output(comb)
    for i,l in ipairs({'Exit code: '..tostring(ec),'---STDOUT---'})do end
    for _,l in ipairs(stdout_lines) do table.insert(output,l) end
    table.insert(output,'---STDERR---')
    for _, l in ipairs(stderr_lines) do table.insert(output,l)end

    Window.display_lines_in_floating_win({body=body,language=codeblock.language},output)
    os.remove(tmp)
  end

  -- local cmd={"cling",tmp}
  local cmd={CLING_RUNNER,tmp}
  print("FlashRunner::Executing the C++ code.")

  -- asynchronous jobstart
  local id=vim.fn.jobstart(cmd,{
    stdout_buffered=true,
    stderr_buffered=true,
    on_stdout= function(_,data,_)
      if data then
        -- print(data)
        for _,l in ipairs(data) do
          if l~= '' and type(l) == "string" then
            table.insert(combined,l)
          end
        end
      end
    end,
    on_stderr= function(_,data,_)
      if data then
        -- print(data)
        for _,l in ipairs(data) do
          if l~= '' and type(l) == "string" then
            table.insert(combined,l)
          end
        end
      end
    end,
    on_exit=on_exit
  })

  if id<=0 then
    vim.notify("Failed to start FlashRunner",vim.log.levels.ERROR)
    os.remove(tmp)
  end

  -- Window.display_lines_in_floating_win({body=body,language=codeblock.language},output)
end


-- execute code 
-- @param codeblock: {body:string, lang:string}
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
