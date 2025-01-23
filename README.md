# neomapper.nvim

A plugin for Neovim that generates a snapshot of your codebase in JSON or XML format

## Features

-  Generates detailed codebase snapshots
-  Supports both JSON and XML output formats
-  Fast and efficient file scanning
-  Configurable file inclusion/exclusion patterns
-  File metadata tracking (size, modification times)
-  Safe content handling with proper encoding

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use 'yourusername/neomapper.nvim'
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    'yourusername/neomapper.nvim',
    config = function()
        require('neomapper').setup()
    end
}
```

## Configuration

```lua
require('neomapper').setup({
    -- Format can be "json" or "xml"
    format = "json",
    
    -- Directories to exclude from scanning
    exclude_dirs = {
        ".git", ".svn", ".hg", ".bzr",
        ".idea", ".vscode", ".DS_Store"
    },
    
    -- File extensions to include
    allowed_extensions = {
        ".lua", ".py", ".js", ".ts", ".html", ".css",
        ".cpp", ".h", ".java", ".go", ".rs", ".php"
    },
    
    -- File extensions to explicitly exclude
    disallowed_extensions = {
        ".pyc", ".pyo", ".obj", ".exe", ".dll",
        ".so", ".dylib", ".cache"
    }
})
```

## Usage

After installation, use the command:

```vim
:Fcomp
```

This will generate a `codebase.json` or `codebase.xml` file (depending on your configuration) in your current working directory.

### Output Format

#### JSON Output
```json
{
    "files": [
        {
            "path": "relative/path/to/file",
            "metadata": {
                "size": 1234,
                "mtime": 1234567890,
                "ctime": 1234567890,
                "type": "file"
            },
            "content": "file contents..."
        }
    ]
}
```

#### XML Output
```xml
<?xml version="1.0" encoding="UTF-8"?>
<codebase>
    <file>
        <path>relative/path/to/file</path>
        <metadata>
            <size>1234</size>
            <mtime>1234567890</mtime>
            <ctime>1234567890</ctime>
            <type>file</type>
        </metadata>
        <content><![CDATA[file contents...]]></content>
    </file>
</codebase>
```

## Use Cases

- Project documentation generation
- Codebase analysis and metrics
- Project structure visualization
- Code backup and versioning
- Integration with external tools

