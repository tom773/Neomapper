local utils = require('fcomp.utils')
local M = {}

-- Pretty print JSON with proper indentation
local function pretty_json(obj, indent)
    indent = indent or ""
    local result = ""
    if type(obj) == "table" then
        if vim.tbl_islist(obj) then
            -- Array
            result = result .. "[\n"
            for i, value in ipairs(obj) do
                result = result .. indent .. "    " .. pretty_json(value, indent .. "    ")
                if i < #obj then
                    result = result .. ","
                end
                result = result .. "\n"
            end
            result = result .. indent .. "]"
        else
            -- Object
            result = result .. "{\n"
            local keys = vim.tbl_keys(obj)
            table.sort(keys)
            for i, key in ipairs(keys) do
                result = result .. indent .. "    \"" .. key .. "\": " .. pretty_json(obj[key], indent .. "    ")
                if i < #keys then
                    result = result .. ","
                end
                result = result .. "\n"
            end
            result = result .. indent .. "}"
        end
    elseif type(obj) == "string" then
        -- Escape special characters in strings
        local escaped = obj:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t')
        result = result .. '"' .. escaped .. '"'
    else
        -- Numbers, booleans, null
        result = result .. tostring(obj)
    end
    
    return result
end

function M.generate(config)
    local current_dir = utils.find_project_root()
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
    -- Convert to JSON string with pretty printing
    local json_str = pretty_json(codebase)
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

