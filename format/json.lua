local utils = require('fcomp.utils')
local M = {}

function M.generate(config)
    local current_dir = vim.fn.getcwd()
    local files = utils.scan_directory(current_dir, config)
    local codebase = {
        files = {}
    }
    for _, file_path in ipairs(files) do
        local relative_path = file_path:sub(#current_dir + 2)
        local content = utils.read_file(file_path)
        local metadata = utils.get_file_metadata(file_path)
        if content and metadata then
            table.insert(codebase.files, {
                path = relative_path,
                metadata = {
                    size = metadata.size,
                    mtime = metadata.mtime.sec,
                    ctime = metadata.ctime.sec,
                    type = metadata.type
                },
                content = content
            })
        end
    end
    -- Convert to JSON string
    local json_str = vim.fn.json_encode(codebase)
    local output_file = io.open(current_dir .. '/codebase.json', 'w')
    if output_file then
        output_file:write(json_str)
        output_file:close()
        vim.notify('Generated codebase.json successfully', vim.log.levels.INFO)
        return true
    else
        vim.notify('Failed to write codebase.json', vim.log.levels.ERROR)
        return false
    end
end

return M

