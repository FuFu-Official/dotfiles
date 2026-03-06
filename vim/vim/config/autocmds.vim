" ============================================================================
" Autocommands
" ============================================================================

augroup vimrc
  autocmd!
  " Return to last edit position
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   execute "normal! g`\"" |
        \ endif

  " Highlight yanked text
  if exists('##TextYankPost')
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  endif

  " Resize splits when window is resized
  autocmd VimResized * wincmd =

  " Close quickfix with q
  autocmd FileType qf nnoremap <buffer> q :close<CR>

  " Close help with q
  autocmd FileType help nnoremap <buffer> q :close<CR>

  " Close man with q
  autocmd FileType man nnoremap <buffer> q :close<CR>

  " Enable spell check for git commits and markdown
  autocmd FileType gitcommit,markdown setlocal spell spelllang=en_us

  " Set filetypes
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
  autocmd BufNewFile,BufRead *.jsonc setlocal filetype=jsonc
augroup END

" ============================================================================
" File Type Specific
" ============================================================================

augroup filetype_settings
  autocmd!
  " Python
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType python setlocal formatoptions+=croqj textwidth=88

  " C/C++
  autocmd FileType c,cpp setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType c,cpp setlocal commentstring=//\ %s

  " Go
  autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab

  " Make
  autocmd FileType make setlocal tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab

  " Lua
  autocmd FileType lua setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

  " JavaScript/TypeScript
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

  " JSON
  autocmd FileType json,jsonc setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

  " HTML/CSS
  autocmd FileType html,css,scss setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

  " Shell
  autocmd FileType sh,bash setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

  " YAML
  autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

  " TOML
  autocmd FileType toml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

  " Dockerfile
  autocmd FileType dockerfile setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
augroup END

" ============================================================================
" NERDTree
" ============================================================================

" Close if only NERDTree remains
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" ============================================================================
" Coc.nvim
" ============================================================================

" Highlight symbol on cursor hold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Update signature help on jump placeholder
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

" ============================================================================
" Format on Save (conform.nvim style)
" ============================================================================

let g:auto_format_enabled = 1

augroup FormatOnSave
  autocmd!
  autocmd BufWritePre *.lua silent call CocAction('format')
  autocmd BufWritePre *.py silent call CocAction('format')
  autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx silent call CocAction('format')
  autocmd BufWritePre *.json,*.jsonc silent call CocAction('format')
  autocmd BufWritePre *.css,*.scss,*.less silent call CocAction('format')
  autocmd BufWritePre *.html silent call CocAction('format')
  autocmd BufWritePre *.md silent call CocAction('format')
  autocmd BufWritePre *.c,*.cpp,*.h,*.hpp silent call CocAction('format')
augroup END
