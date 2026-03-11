# Vim Configuration

A Vim configuration that mirrors the LazyVim Neovim setup.

## Installation

### Symlink

```sh
ln -sf ~/Dev/dotfiles/vim/vimrc ~/.vimrc
ln -sf ~/Dev/dotfiles/vim/vim ~/.vim
```

### Install Plugins

Open Vim and run:

```vim
:PlugInstall
```

Coc extensions will auto-install on first launch.

## Prerequisites

- Vim 8.2+ or Neovim 0.5+
- Node.js (for coc.nvim)
- curl (for vim-plug installation)
- git (for vim-fugitive)
- ripgrep (for Rg search)

## File Structure

```
vim/
├── coc-settings.json    # LSP settings
├── config/
│   ├── options.vim      # General settings
│   ├── keymaps.vim      # Keymaps
│   └── autocmds.vim     # Autocommands
└── plugins/
    ├── coc.vim          # LSP/completion
    ├── fzf.vim          # Fuzzy finder
    ├── git.vim          # Git integration
    ├── ui.vim           # Colorscheme, statusline, explorer
    └── editor.vim       # Editor plugins
```

## Colorschemes

- **catppuccin** (mocha flavour)
- **rose-pine** (moon variant)

Edit `vim/plugins/ui.vim` to change:

```vim
colorscheme catppuccin_mocha
" or
colorscheme rosepine_moon
```

## Features

### Auto Format on Save

Formats Lua, Python, JavaScript, TypeScript, JSON, CSS, HTML, Markdown, C, C++ files automatically.

Toggle with `<leader>uf`

### Better Search

- `n`/`N` centers search results
- `<Esc>` clears search highlight

### Move Lines

- `<A-j>` / `<A-k>` - Move current line up/down

### UI Toggles (LazyVim style)

| Key          | Action                         |
| ------------ | ------------------------------ |
| `<leader>uL` | Toggle relative line numbers   |
| `<leader>ul` | Toggle line numbers            |
| `<leader>us` | Toggle spell check             |
| `<leader>uw` | Toggle wrap                    |
| `<leader>uc` | Toggle cursor column           |
| `<leader>ub` | Toggle background (dark/light) |
| `<leader>ud` | Toggle diagnostics             |
| `<leader>uh` | Toggle inlay hints             |
| `<leader>uC` | Toggle conceal                 |
| `<leader>uf` | Toggle auto format             |
| `<leader>uT` | Toggle transparency            |

## Keymaps (LazyVim Style)

Leader key: `<Space>`

### General

| Key          | Mode   | Action                             |
| ------------ | ------ | ---------------------------------- |
| `jk`         | Insert | Exit insert mode                   |
| `q`          | Visual | Exit visual mode                   |
| `J`          | Visual | Move selected lines down           |
| `K`          | Visual | Move selected lines up             |
| `J`          | Normal | Join lines without cursor jump     |
| `p`          | Visual | Paste without overwriting register |
| `x`          | Normal | Delete character without copying   |
| `<Esc>`      | Normal | Clear search highlight             |
| `<C-s>`      | All    | Save file                          |
| `<leader>ur` | Normal | Redraw / Clear hlsearch            |
| `<leader>fn` | Normal | New file                           |

### Buffers

| Key               | Action                   |
| ----------------- | ------------------------ |
| `<S-h>` / `<S-l>` | Prev/Next buffer         |
| `[b` / `]b`       | Prev/Next buffer         |
| `<leader>bb`      | Switch to other buffer   |
| `<leader>bd`      | Delete buffer            |
| `<leader>bo`      | Delete other buffers     |
| `<leader>bD`      | Delete buffer and window |

### Windows

| Key                      | Action             |
| ------------------------ | ------------------ |
| `<C-h/j/k/l>`            | Navigate windows   |
| `<C-Up/Down/Left/Right>` | Resize windows     |
| `<leader>-`              | Split window below |
| `<leader>\|`             | Split window right |
| `<leader>wd`             | Delete window      |

### Tabs

| Key                    | Action           |
| ---------------------- | ---------------- |
| `<leader><Tab><Tab>`   | New tab          |
| `<leader><Tab>d`       | Close tab        |
| `<leader><Tab>]` / `[` | Next/Prev tab    |
| `<leader><Tab>l`       | Last tab         |
| `<leader><Tab>o`       | Close other tabs |

### Find (FZF)

| Key               | Action           |
| ----------------- | ---------------- |
| `<leader><space>` | Find files       |
| `<leader>,`       | Buffers          |
| `<leader>/`       | Grep             |
| `<leader>:`       | Command history  |
| `<leader>ff`      | Find files       |
| `<leader>fF`      | Find files (cwd) |
| `<leader>fr`      | Recent files     |
| `<leader>fb`      | Buffers          |
| `<leader>fg`      | Git files        |

### Search

| Key          | Action                   |
| ------------ | ------------------------ |
| `<leader>sg` | Grep                     |
| `<leader>sw` | Search word under cursor |
| `<leader>sb` | Buffer lines             |
| `<leader>sh` | Help pages               |
| `<leader>sk` | Keymaps                  |
| `<leader>sc` | Command history          |
| `<leader>sm` | Marks                    |

### LSP

| Key          | Action                |
| ------------ | --------------------- |
| `gd`         | Go to definition      |
| `gD`         | Go to declaration     |
| `gI`         | Go to implementation  |
| `gy`         | Go to type definition |
| `gr`         | References            |
| `K`          | Hover documentation   |
| `gK`         | Signature help        |
| `<leader>cr` | Rename                |
| `<leader>ca` | Code action           |
| `<leader>cf` | Format                |
| `<leader>co` | Organize imports      |

### Diagnostics

| Key          | Action               |
| ------------ | -------------------- |
| `[d` / `]d`  | Prev/Next diagnostic |
| `[e` / `]e`  | Prev/Next error      |
| `[w` / `]w`  | Prev/Next warning    |
| `<leader>cd` | Diagnostics list     |
| `<leader>xl` | Location list        |
| `<leader>xq` | Quickfix list        |

### Git

| Key          | Action         |
| ------------ | -------------- |
| `<leader>gg` | Git status     |
| `<leader>gb` | Git blame      |
| `<leader>gd` | Git diff       |
| `<leader>gl` | Git log        |
| `[h` / `]h`  | Prev/Next hunk |
| `<leader>hp` | Preview hunk   |
| `<leader>hs` | Stage hunk     |
| `<leader>hu` | Undo hunk      |

### Comments (vim-commentary)

| Key   | Action                    |
| ----- | ------------------------- |
| `gcc` | Toggle line comment       |
| `gc`  | Toggle comment (operator) |
| `gco` | Add comment below         |
| `gcO` | Add comment above         |

### Surround (mini.surround style)

| Key   | Action              |
| ----- | ------------------- |
| `gsa` | Add surrounding     |
| `gsd` | Delete surrounding  |
| `gsr` | Replace surrounding |

### Explorer

| Key                        | Action            |
| -------------------------- | ----------------- |
| `<leader>fe` / `<leader>e` | Toggle explorer   |
| `<leader>fE` / `<leader>E` | Find current file |

## Plugins

| Plugin           | Purpose               |
| ---------------- | --------------------- |
| coc.nvim         | LSP, completion       |
| lightline.vim    | Status line           |
| nerdtree         | File explorer         |
| fzf.vim          | Fuzzy finder          |
| vim-gitgutter    | Git signs             |
| vim-fugitive     | Git commands          |
| vim-surround     | Surround text objects |
| vim-commentary   | Commenting            |
| vim-visual-multi | Multiple cursors      |
| vim-polyglot     | Syntax highlighting   |
| vim-smoothie     | Smooth scrolling      |
| vim-devicons     | File icons            |
| vim-repeat       | Repeat plugin actions |
| catppuccin       | Colorscheme           |
| rose-pine        | Colorscheme           |

## Coc Extensions

Auto-installed:

- coc-json, coc-pyright, coc-clangd
- coc-sh, coc-html, coc-css
- coc-yaml, coc-toml, coc-markdownlint
- coc-lua, coc-prettier, coc-emoji
- coc-tsserver, coc-snippets

## Formatters

The following formatters are configured for auto-formatting:

- **Lua**: stylua
- **Python**: black, isort
- **JavaScript/TypeScript**: prettier
- **JSON**: prettier
- **CSS/HTML**: prettier
- **C/C++**: clang-format
- **Markdown**: prettier

Install them system-wide for auto-format to work.
