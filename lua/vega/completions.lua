local M = {}
function M.create_initial_message(prompt) -- make json request to server with given prompt
    local jsoned_request = ''
    local request = {
        messages = {
            {
                role = 'user',
                content = prompt,
            }
        }
    }
    jsoned_request = vim.json.encode(request)
    return jsoned_request -- returns request json
end

return M
