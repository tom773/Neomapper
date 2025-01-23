local utils = require('fcomp.utils')

local M = {}

local function xml_encode(str)
    local replacements = {
        ['&'] = '&amp;',
        ['<'] = '&lt;',
        ['>'] = '&gt;',
        ['"'] = '&quot;',
        ["'"] = '&apos;'
    }
    return(str:gsub('[&<>"\']', replacements))
end

function M.generate(config)
    local current_dir = utils.find_project_root()
    local files = utils.scan_directory(current_dir, config)
    local xml_content = '<?xml version="1.0" encoding="UTF-8"?>\n'
    xml_content = xml_content .. '<codebase>\n'
    for _, file_path in ipairs(files) do
        local relative_path = file_path:sub(#current_dir + 2)
        local content = utils.read_file(file_path)
        local metadata = utils.get_file_metadata(file_path)
        if content and metadata then
            xml_content = xml_content .. '  <file>\n'
            xml_content = xml_content .. '    <path>' .. xml_encode(relative_path) .. '</path>\n'
            xml_content = xml_content .. '    <metadata>\n'
            xml_content = xml_content .. '      <size>' .. metadata.size .. '</size>\n'
            xml_content = xml_content .. '      <mtime>' .. metadata.mtime.sec .. '</mtime>\n'
            xml_content = xml_content .. '      <ctime>' .. metadata.ctime.sec .. '</ctime>\n'
            xml_content = xml_content .. '      <type>' .. metadata.type .. '</type>\n'
            xml_content = xml_content .. '    </metadata>\n'
            xml_content = xml_content .. '    <content><![CDATA[' .. content .. ']]></content>\n'
            xml_content = xml_content .. '  </file>\n'
        end
    end
    xml_content = xml_content .. '</codebase>'
    local output_file = io.open(current_dir .. '/codebase.xml', 'w')
    if output_file then
        output_file:write(xml_content)
        output_file:close()
        vim.notify('Generated codebase.xml successfully', vim.log.levels.INFO)
        return true
    else
        vim.notify('Failed to write codebase.xml', vim.log.levels.ERROR)
        return false
    end
end

return M
