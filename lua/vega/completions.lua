local M = {}
function M.create_initial_message(prompt)
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
    return jsoned_request
end

return M
