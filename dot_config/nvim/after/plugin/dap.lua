local dap, dapui =require("dap"),require("dapui")

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"]=function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"]=function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"]=function()
  dapui.close()
end

vim.keymap.set('n', '<F9>', require 'dap'.continue)
vim.keymap.set('n', '<F8>', require 'dap'.step_over)
vim.keymap.set('n', '<F7>', require 'dap'.step_into)
vim.keymap.set('n', '<F20>', require 'dap'.step_out)
vim.keymap.set('n', '<leader>b', require 'dap'.toggle_breakpoint)
