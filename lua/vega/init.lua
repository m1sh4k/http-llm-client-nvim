local M = {}

local client = require('vega.client')
function M.setup()
  vim.api.nvim_create_user_command('CreateCompletion', function(opts)
    client.CreateCompletion(opts.args)
  end, {})
end

return M
