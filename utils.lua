
local M = {}

function M.find_project_root()
    local current = vim.fn.getcwd()
    local root_markers = {'.git', '.svn', '.hg', '.bzr', 'package.json', 'Cargo.toml', 'go.mod'}
    while current ~= '/' do
        for _, marker in ipairs(root_markers) do
            if vim.fn.isdirectory(current .. '/' .. marker) == 1 or 
               vim.fn.filereadable(current .. '/' .. marker) == 1 then
                return current
            end
        end
        current = vim.fn.fnamemodify(current, ':h')
    end
    -- If no root marker found, return current directory
    return vim.fn.getcwd()
end

function M.is_excluded(path, config)
    for _, excluded in ipairs(config.exclude_dirs) do
        if path:match(excluded) then
            return true
        end
    end
    return false
end

function M.is_excluded_file(path, config)
    local filename = path:match("([^/]+)$")  -- Get just the filename from the path
    for _, excluded in ipairs(config.exclude_files) do
        if filename == excluded then  -- Exact match comparison
            return true
        end
    end
    return false
end

function M.is_allowed_extension(path, config)
    for _, ext in ipairs(config.disallowed_extensions) do
        if path:match(ext .. "$") then
            return false
        end
    end
    if #config.allowed_extensions == 0 then
        return true
    end
    for _, ext in ipairs(config.allowed_extensions) do
        if path:match(ext .. "$") then
            return true
        end
    end
    return false
end

function M.read_file(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return content
end

function M.get_file_metadata(path)
    local stat = vim.loop.fs_stat(path)
    if stat then
        return {
            size = stat.size,
            mtime = stat.mtime,
            ctime = stat.ctime,
            type = stat.type
        }
    end
    return nil
end

function M.scan_directory(dir, config)
    local files = {}
    local handle = vim.loop.fs_scandir(dir)
    while handle do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then break end

        local path = dir .. '/' .. name
        if not M.is_excluded(path, config) then
            if M.is_excluded_file(path, config) then
                goto continue_scan
            end
            if type == 'directory' then
                local sub_files = M.scan_directory(path, config)
                for _, file in ipairs(sub_files) do
                    table.insert(files, file)
                end
            elseif type == 'file' and M.is_allowed_extension(path, config) then
                table.insert(files, path)
            end
        end
        ::continue_scan::
    end
    return files
end

return M

