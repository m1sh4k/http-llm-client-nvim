local M = {}

function M.CreateCompletion(prompt)
    local completions = require('vega.completions')
    local pattern_code = "```.-```"
    local to_insert = ''
    local client = vim.uv.new_tcp()
    if not client then
        error("Failed to create TCP client handle")
        return
    end
    local host, port = "127.0.0.1", 9999
--   
    vim.uv.tcp_connect(client, host, port, function (error)
        if error then
            print("Connection error:", error)
            vim.uv.close(client)
            return
        end
    end)
    local jsoned = completions.create_initial_message(string.sub(prompt, 2, -2))
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
    local h = io.popen("curl -s http://localhost:9999/v1/chat/completions -H 'Content-Type: application/json' -d '" .. jsoned .. "'")
    local response = h:read('*a')
    h:close()
    local llm_answer = string.match(vim.json.decode(response)['choices'][1]['message']['content'], pattern_code):gsub("```$", ""):gsub("```.-\n", "")
--    print(response)
    print(llm_answer)
end

return M
