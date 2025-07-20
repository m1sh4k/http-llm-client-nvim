local M = {}

-- load modules
local client = require('vega.client')
local managment = require('vega.managment')
-- set commands
function M.setup()
  vim.api.nvim_create_user_command('CodeCompletion', function(opts)
    client.CodeCompletion(opts.args)
  end, {})
  vim.api.nvim_create_user_command('CreateCompletion', function(opts)
    client.CreateCompletion(opts.args)
  end, {})
  vim.api.nvim_create_user_command('CommitCompletion', function()
    managment.CommitCompletion()
  end, {})

end

return M
