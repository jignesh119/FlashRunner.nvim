local M={}

M.make_tempfile=function()
  local tmpname=vim.fn.tempname().."cpp"
  return tmpname
end


-- @param output: string[]
-- @return exit_code: number
-- @return stdout: string[]
-- @return stderr: string[]
M.parse_runner_output=function(output)
  -- runner prints:
  -- <exit_code>\n---STDOUT---\n...\n---STDERR---\n...
  -- print("received in parse_runner_op",vim.inspect(output))
  local ec=tonumber(output[1]) or 0
  -- print("silce ",vim.inspect(vim.list_slice(output,2,#output)))
  local joined=table.concat(vim.list_slice(output,2,#output),"\n")
  local stdout_m="stdout"
  local stderr_m="strerr"
  local stdout=""
  local stderr=""
  local stdout_start,stdout_end=string.find(joined,stdout_m,1,true)
  local stderr_start,stderr_end=string.find(joined,stderr_m,1,true)

  if stdout_start and stderr_start then
    stdout=string.sub(joined,stdout_end+1,stderr_start-1)
    stderr=string.sub(joined,stderr_end+1)
  else
    stdout=joined
  end
  return ec,vim.split(stdout,"\n"),vim.split(stderr,"\n")
end

return M
