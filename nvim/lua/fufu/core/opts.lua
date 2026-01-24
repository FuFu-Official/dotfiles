local o = vim.opt

o.relativenumber = true -- Enable relative line numbering (useful for movement commands)
o.number = true -- Enable absolute line numbering

-- Appearance
-- o.termguicolors = true -- Enable true colors (24-bit color support)
-- o.background = "dark" -- Set default background to dark (helps colorschemes load correctly)
-- o.signcolumn = "yes" -- Always show the sign column (prevents text jumping when signs appear)
-- o.cmdheight = 1 -- Set the command-line height
-- o.cursorline = true -- Highlight the current cursor line

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true -- Convert all typed tabs into spaces
o.autoindent = true -- Copy indent from the current line when starting a new one

-- Line Wrapping
o.wrap = true -- Enable line wrapping
o.breakindent = true
o.linebreak = true
o.showbreak = "↳ "

-- o.backspace = "indent,eol,start" -- Allow backspacing over indent, end-of-line, and insert-mode start
o.clipboard:append("unnamedplus") -- Use system clipboard as the default register ("unnamedplus" means system clipboard)
o.undofile = true -- Enable persistent undo history (undo changes even after closing and reopening)

o.swapfile = false -- Disable swap files (improves performance, but less crash resilience)

o.ignorecase = true -- Ignore case when searching
o.smartcase = true -- If search pattern contains mixed case, assume case-sensitive search

o.splitright = true -- When splitting vertically, place new window to the right
o.splitbelow = true -- When splitting horizontally, place new window to the bottom

-- Scrolling & Context
o.scrolloff = 8 -- Lines kept above/below the cursor when scrolling vertically
-- opt.sidescrolloff = 4 -- Columns kept on the sides when scrolling horizontally

o.completeopt = { "menuone", "noselect" } -- Completion Menu

-- Update Time (Crucial for LSP/Plugins)
-- o.updatetime = 50 -- Set time (ms) to wait for `CursorHold` events (affects LSP features/Git signs)

o.virtualedit = "block" -- Allow cursor to move freely in visual block mode

o.jumpoptions = "stack"

local g = vim.g

g.loaded_perl_provider = 0 -- Disable perl provider
g.loaded_ruby_provider = 0 -- Disable ruby provider
