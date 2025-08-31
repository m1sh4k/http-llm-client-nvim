local M = {}

function M.CommitCompletion()
    -- get info about completion buffer
    local window = 0
    local buffer = vim.api.nvim_win_get_buf(window)
    local row, col = unpack(vim.api.nvim_win_get_cursor(window))
    local edited = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), { force = true }) -- close completion buffer
    window = 0 -- current window 
    buffer = vim.api.nvim_win_get_buf(window) -- get current buffer
    row, col = unpack(vim.api.nvim_win_get_cursor(window)) -- get current row and column
    vim.api.nvim_buf_set_text(buffer, row - 1, col, row - 1, col, edited) -- write completion into cursor position
end

return M
