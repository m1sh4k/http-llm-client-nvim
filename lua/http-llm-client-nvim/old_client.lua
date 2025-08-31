local M = {}



function M.create_completion(args)
    local host, port = "127.0.0.1", 9999  -- changed 'local host' instead of 'local localhost'
    local socket = require("socket")
    local tcp = assert(socket.tcp())
    local pattern_code = "```.-```"
    local to_insert = ""

    tcp:connect(host, port)
    tcp:send(args)
--    tcp:send("write python function that takes two int as arguments and retuens наименьший общий делитель, write only code, no comments or notes at all and write another function that returns sum of arguments")

-- changed receive("*a") to receive("*l") to avoid hanging
    local data, err, partial = tcp:receive("*a")

--print(data)
--print('---------------')

    for i in string.gmatch(data, pattern_code, 1) do
        to_insert = to_insert .. "\n" .. i
    end
    to_insert = to_insert:gsub("```.-\n", "")
    to_insert = to_insert:gsub("```$", "")
--print(string.sub(data, string.find(data, pattern_code, 1))) --type: ignore
    print(to_insert)
    tcp:close()  -- close the socket after use
end

return M
