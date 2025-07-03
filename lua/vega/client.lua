local M = {}

Completions = require('vega.completions')
Config, Config = pcall(require, "Config")
if not Config then
   print('! no Config file found, using default')
   Config = require('default_config')
end

function M.Completion(prompt)

    local client = vim.uv.new_tcp()
    if not client then
        error("Failed to create TCP client handle")
        return
    end
--   
    vim.uv.tcp_connect(client, Config.host, Config.port, function (error)
        if error then
            print("Connection error:", error)
            vim.uv.close(client)
            return
        end
    end)
    local jsoned = Completions.create_initial_message(string.sub(prompt, 2, -2))
    --print('jsoned: ' .. jsoned)
    --[[vim.uv.write(client, jsoned, function (sending_error)
        if sending_error then
            print('Sending error:', sending_error)
            vim.uv.close(client)
            return
        end
    end)
    vim.uv.read_start(client, function (read_error, response)
        if read_error then
            print('Read error: ', read_error)
            vim.uv.close(client)
            return
        end
        if response then
            for i in string.gmatch(response, pattern_code, 1) do
                to_insert = to_insert .. "\n" .. i
            end
            to_insert = to_insert:gsub("```.-\n", "")
            to_insert = to_insert:gsub("```$", "")
            print(to_insert)
       else
            vim.uv.close(client)
        end

    end)]]
    local h = io.popen("curl -s http://localhost:" .. tostring(Config.port) .. "/v1/chat/completions -H 'Content-Type: application/json' -d '" .. jsoned .. "'")
    ---@type string
    local response = h and h:read('*a')
    if h then
        pcall(h.close, h)  -- Safely attempt to close
    end
    return response
end

function M.CodeCompletion(prompt)
    local response = M.Completion(prompt .. Config.code_extra_prompt)
    local pattern_code = "```.-```"
    --local to_insert = ''
    if not response then
        print('!no llm response!')
        return
    end
    local llm_answer = string.match(vim.json.decode(response)['choices'][1]['message']['content'], pattern_code):gsub("```$", ""):gsub("```.-\n", "")
    print(llm_answer)
end

function M.CreateCompletion(prompt)
    local response = M.Completion(prompt)
    if not response then
        print('!no llm response!')
        return
    end

    local llm_answer = vim.json.decode(response)['choices'][1]['message']['content']
    print(llm_answer)
end

return M
