
local M = {
    config = {}
}

local default_config = {
    format = "json",  -- can be "xml" or "json"
    exclude_dirs = {".git", ".svn", ".hg", ".bzr", ".idea", ".vscode", ".DS_Store", "node_modules", "dist"},
    exclude_files = {".gitignore", ".gitmodules", ".gitattributes", ".hgignore", ".bzrignore", ".npmignore",
        ".dockerignore", ".eslintignore", ".prettier", ".prettierignore", "package.json", "package-lock.json",
        "codemap.json", "codebase.json", "codemap.xml", ".stylelintignore", ".stylelint", ".stylelintrc", ".stylelintrc.js", 
        ".stylelintrc.json", ".stylelintrc.yaml", ".stylelintrc.yml"},
    allowed_extensions = {".c", ".cpp", ".h", ".hpp", ".java", ".py", ".js", ".ts", ".html", ".css", ".scss",
        ".json", ".xml", ".yaml", ".yml", ".md", ".txt", ".sh", ".bat", ".ps1", ".lua", ".vim", ".sql", 
        ".php", ".rb", ".pl", ".go"},
    disallowed_extensions = {".pyc", ".pyo", ".DS_Store", ".class", ".o", ".obj", ".exe", ".dll", ".so", ".dylib",
        ".cache", ".swp", ".swo", ".swn"},
}

function M.setup(user_config)
    M.config.allowed_extensions = default_config.allowed_extensions
    M.config.exclude_dirs = default_config.exclude_dirs
    M.config.format = default_config.format
    M.config.disallowed_extensions = default_config.disallowed_extensions
    M.config.exclude_files = default_config.exclude_files
    if user_config then
        if user_config.allowed_extensions then M.config.allowed_extensions = user_config.allowed_extensions end
        if user_config.exclude_dirs then M.config.exclude_dirs = user_config.exclude_dirs end
        if user_config.exclude_files then M.config.exclude_files = user_config.exclude_files end
        if user_config.format then M.config.format = user_config.format end
        if user_config.disallowed_extensions then M.config.disallowed_extensions = user_config.disallowed_extensions end
    end
    vim.api.nvim_create_user_command('Neomap', function()
        M.generate()
    end, {})
end

function M.generate()
    local formatter
    if M.config.format == "xml" then
        formatter = require('fcomp.format.xml')
    elseif M.config.format == "json" then
        formatter = require('fcomp.format.json')
    else
        vim.notify('Invalid format specified. Use "xml" or "json"', vim.log.levels.ERROR)
        return
    end
    formatter.generate(M.config)
end

return M
