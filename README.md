## Description

Minimalistic neovim plugin written in pure lua that allows you to ask openai json compatible llm server for completion right inside the text editor. (for now it does not support authorization, functional tested on local llama.cpp server)
## Installation

- No build after installation needed

Dependencies:
- curl (must be accessible with `curl` terminal command)
- neovim
- lua


To initialize plugin , `lua/vega/init.lua` setup must be ran at neovim startup (may be lazy).

lazy.nvim simple setup example:

```lua
{
    "m1sh4k/http-llm-client.nvim",
    config = true
},
```

## Initial configuration

Plugin uses config file `lua/vega/config.lua` (it does NOT exist after installation, you can start just from copying data from `lua/vega/default_config.lua` and then modifying). If importing `config.lua` throws errors *(e.g. file does not exist)* then plugin uses `lua/vega/default_config.lua` (path provided relative to the plugin root directory).


## Usage

1. `CreateCompletion "<prompt>"` — asks model for a completion with given prompt in quotes (completion will be printed in nvim terminal).
2. `CodeCompletion "<prompt>"` — asks model to write some code according to prompt in quotes and insert it into temporary buffer `completion buffer`  (adds some extra prompt after argument (`code_extra_prompt`) to avoid unneeded notes and shows only code). Throws error if model does not return code or it is not in markdown format so code cannot be parsed.
3. `CommitCompletion` — write content stored in completion buffer to current source buffer cursor position and delete completion buffer.

## Configuration
### Example

Define config variable `var` with content `MEDIC!`:
```lua
-- after 'M' declaration
M.var = "MEDIC!"
```

### Config variables
- `host` \[string\] — llm server ipv4 address (default `127.0.0.1`)
- `port` \[int\] — llm server port (default `8080`)
- `code_extra_prompt` \[string\] — extra prompt for `CodeCompletion` used to decrease inference tokens by removing e.g. non-code explanations and usage examples

