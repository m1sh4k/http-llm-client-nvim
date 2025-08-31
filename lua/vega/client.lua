local M = {}

-- modules loading
Completions = require('vega.completions')
Config_loaded_successfull, Config = pcall(require, "config.config")
-- load config if exists else default config
if not Config_loaded_successfull then
   print('! no Config file found, using default')
   Config = require('config.default_config')
end

function M.Completion(prompt) -- returns llm completion for given prompt 
    local jsoned = Completions.create_initial_message(string.sub(prompt, 2, -2)) -- make json input for server with given prompt
    local h = io.popen("curl -s http://" .. Config.host ..":" .. tostring(Config.port) .. "/v1/chat/completions -H 'Content-Type: application/json' -d '" .. jsoned .. "'") -- send curl http request for completion
    ---@type string
    local response = h and h:read('*a') -- parse server response
    if h then -- check if response exists
        pcall(h.close, h)  -- Safely attempt to close
    end
    return vim.json.decode(response)['choices'][1]['message']['content'] -- return llm answer extracted from server json output
end

function M.CodeCompletion(prompt) -- writes code completion to temporary buffer called "completion buffer"
    vim.cmd('new') -- create new window
    local response = M.Completion(prompt .. Config.code_extra_prompt) -- get llm response using extra prompt to reduce token inference quantity and time
    local pattern_code = "```.-```" -- pattern to parse markdown code blocks
    if not response then
        print('!no llm response!') -- if server returns no response
        return
    end
    local llm_answer = string.match(response, pattern_code):gsub("```$", ""):gsub("```.-\n", "") -- extract all code 
    local window = 0 -- current window (completion)
    local buffer = vim.api.nvim_win_get_buf(window) -- get completion buffer
    local row, col = unpack(vim.api.nvim_win_get_cursor(window)) -- get cursor pos in completion buffer
    local insert_arr = {}
    local i = 1
    -- split completion text by lines 
    for str in llm_answer:gmatch(".-\n") do
        insert_arr[i] = str:gsub("\n", '')
        i = i + 1
    end
    vim.api.nvim_buf_set_text(buffer, row - 1, col, row - 1, col, insert_arr) -- insert completion into completion buffer
end

function M.CreateCompletion(prompt) -- simple llm completion without extra formatting
    local response = M.Completion(prompt) -- get llm response
    -- check if response exists
    if not response then
        print('!no llm response!')
        return
    end

    print(response) -- prints response
end

return M
