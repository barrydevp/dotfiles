local dap = require('dap')

vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

vim.fn.sign_define('DapStopped', {text='🟢', texthl='', linehl='', numhl=''})

-- adapters

dap.adapters.lldb = {
  type = 'executable',
  command = os.getenv("HOME") .. '/.local/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}


-- configurations

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
    -- pid = require('dap.utils').pick_process,
  },
}


dap.configurations.c = dap.configurations.cpp

dap.configurations.rust = dap.configurations.cpp


