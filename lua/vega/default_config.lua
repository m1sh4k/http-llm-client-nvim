local M = {}
    M.host = "127.0.0.1" -- server ipv4
    M.port = 8080 -- server port
    M.code_extra_prompt = " write only code no explanation no notes no usage example only minimal comments in code" -- extra prompt used in CodeCompletion to make llm response cleaner and better
return M
