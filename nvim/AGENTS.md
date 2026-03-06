# AGENTS.md

This file provides guidance for AI coding agents working in this Neovim configuration repository.

## Project Overview

This is a LazyVim-based Neovim configuration. It uses the lazy.nvim plugin manager with a modular plugin structure. Configuration is split between core settings (`lua/config/`) and plugins (`lua/plugins/`).

## Build/Lint/Test Commands

This is a configuration repository, not a buildable project. However, there are linting and formatting commands:

### Formatting
```bash
stylua lua/ init.lua matugen.lua
```

### Linting
```bash
# Lua linting (if luacheck is installed)
luacheck lua/ init.lua matugen.lua

# Markdown linting
markdownlint-cli2 **/*.md
```

### Validation
```bash
# Validate Neovim config loads without errors
nvim --headless -c 'q' 2>&1 | grep -i error
```

## Project Structure

```
nvim/
├── init.lua              # Entry point, bootstraps lazy.nvim and matugen
├── lua/
│   ├── config/
│   │   ├── lazy.lua      # lazy.nvim setup and bootstrap
│   │   ├── keymaps.lua   # Custom keymaps
│   │   ├── options.lua   # Neovim options
│   │   └── autocmds.lua   # Autocommands and user commands
│   └── plugins/          # Plugin specifications
│       ├── lsp.lua       # LSP configuration
│       ├── conform.lua    # Formatter configuration
│       ├── lint.lua       # Linter configuration
│       ├── treesitter.lua # Treesitter parsers
│       ├── blink.lua      # Completion configuration
│       ├── ui.lua         # Colorschemes and UI plugins
│       └── ...            # Other plugins
├── stylua.toml           # StyLua formatter config
├── .neoconf.json         # Neovim LSP config
└── lazy-lock.json        # Pinned plugin versions
```

## Code Style Guidelines

### Lua Formatting (stylua.toml)

- **Indentation**: 2 spaces
- **Column Width**: 120 characters
- Use StyLua for all Lua formatting

### Plugin File Structure

Plugin files in `lua/plugins/` must return a table of plugin specs:

```lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",
    opts = {
      option_name = "value",
    },
    config = function(_, opts)
      require("plugin-name").setup(opts)
    end,
  },
}
```

### Key Guidelines

1. **Return tables**: Each plugin file returns a table (can be single plugin or list)
2. **Trailing commas**: Always use trailing commas in multi-line tables
3. **Function style**: Use `function(_, opts)` pattern for config functions
4. **Opts vs config**: Prefer `opts` for simple options, `config` function for complex setup
5. **Lazy loading**: Use `event`, `cmd`, `keys`, or `ft` for lazy loading when appropriate

### Keymaps

Use `vim.keymap.set()` with descriptive `desc`:

```lua
vim.keymap.set("n", "<leader>xx", function()
  -- action
end, { desc = "Description of what this does" })
```

### Autocommands

Use `vim.api.nvim_create_autocmd()` with augroups:

```lua
vim.api.nvim_create_autocmd("EventName", {
  group = vim.api.nvim_create_augroup("group-name", { clear = true }),
  callback = function()
    -- action
  end,
})
```

### User Commands

Use `vim.api.nvim_create_user_command()`:

```lua
vim.api.nvim_create_user_command("CommandName", function(opts)
  -- use opts.args for arguments
end, {
  nargs = "?",
  complete = "dir",
  desc = "Command description",
})
```

### LSP Server Configuration

Configure servers in `lua/plugins/lsp.lua` under `opts.servers`:

```lua
opts = {
  servers = {
    server_name = {
      on_init = function(client)
        -- initialization logic
      end,
      settings = {
        ServerSettings = {
          option = "value",
        },
      },
    },
  },
}
```

### Formatter Configuration

Configure in `lua/plugins/conform.lua`:

```lua
opts = {
  formatters_by_ft = {
    filetype = { "formatter-name" },
    another_ft = { "formatter1", "formatter2", stop_after_first = true },
  },
}
```

### Linter Configuration

Configure in `lua/plugins/lint.lua`:

```lua
opts = {
  linters = {
    ["linter-name"] = {
      args = { "--arg", "value" },
    },
  },
}
```

## Naming Conventions

- **Plugin files**: lowercase with `.lua` extension, named after functionality
- **Local variables**: `snake_case`
- **Functions**: `snake_case` for local functions
- **Keys**: Use `<leader>` prefix for custom keymaps
- **Augroups**: Use descriptive names prefixed with plugin or feature name

## Common Patterns in This Config

### Conditional Plugin Loading

```lua
{
  "plugin/name",
  enabled = true,
  cond = function()
    return vim.fn.executable("required-tool") == 1
  end,
}
```

### Override Default Options

```lua
{
  "existing-plugin",
  opts = function(_, opts)
    opts.some_option = "new-value"
    return opts
  end,
}
```

### Disable Default Plugin

```lua
{
  "disabled-plugin",
  enabled = false,
}
```

## Dependencies

- **stylua**: Lua formatter
- **lua_ls**: Lua language server (for LSP)
- **markdownlint-cli2**: Markdown linter
- Various formatters: black, isort, prettier, dprint, clang-format, kdlfmt
- Various LSP servers: pyright, clangd, fish_lsp, cmake, hyprls, bashls, texlab, jsonls, markdown_oxide

## Important Notes

1. **Don't comment code**: This config avoids comments in Lua files unless absolutely necessary
2. **No semicolons**: Lua doesn't require semicolons, don't use them
3. **Module imports**: Use `require("module")` without `.init` suffix
4. **Vim API**: Prefer `vim.uv` over `vim.loop` (newer API)
5. **Error handling**: Use `pcall()` for potentially failing operations
6. **Home directory**: Use `os.getenv("HOME")` instead of `"~"` for paths