" ============================================================================
" coc.nvim Configuration (LSP - LazyVim Style)
" ============================================================================

" coc extensions (auto-install)
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-pyright',
  \ 'coc-clangd',
  \ 'coc-sh',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-yaml',
  \ 'coc-toml',
  \ 'coc-markdownlint',
  \ 'coc-lua',
  \ 'coc-prettier',
  \ 'coc-emoji',
  \ 'coc-tsserver',
  \ 'coc-snippets',
  \ ]

" ============================================================================
" Completion
" ============================================================================

" Tab completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" CR to confirm completion
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" C-j/C-k for completion navigation
inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
inoremap <silent><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"

" Trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" ============================================================================
" LSP Keymaps (LazyVim Style)
" ============================================================================

" LSP Info
nnoremap <leader>cl :CocInfo<CR>

" GoTo navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-declaration)
nmap <silent> gI <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" Hover documentation
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Signature help
nnoremap <silent> gK :call CocActionAsync('showSignatureHelp')<CR>
inoremap <silent> <C-k> <C-r>=coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-k>"<CR>

" Rename
nmap <leader>cr <Plug>(coc-rename)

" Code actions
nmap <leader>ca <Plug>(coc-codeaction-cursor)
nmap <leader>cA <Plug>(coc-codeaction-source)
xmap <leader>ca <Plug>(coc-codeaction-selected)
nmap <leader>cc <Plug>(coc-codelens-action)

" Format
nmap <leader>cf <Plug>(coc-format)
xmap <leader>cf <Plug>(coc-format-selected)
nmap <leader>cF <Plug>(coc-format)

" Organize imports
nnoremap <leader>co :call CocAction('runCommand', 'editor.action.organizeImport')<CR>

" ============================================================================
" Diagnostics (LazyVim Style)
" ============================================================================

nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
nmap <silent> [w <Plug>(coc-diagnostic-prev-warning)
nmap <silent> ]w <Plug>(coc-diagnostic-next-warning)

nnoremap <leader>cd :CocList diagnostics<CR>
nnoremap <leader>cD :CocList diagnostics --current-buffer<CR>
nnoremap <leader>xl :CocList locationlist<CR>
nnoremap <leader>xq :CocList quickfix<CR>

" Line diagnostics
nnoremap <silent> <leader>cL :call CocActionAsync('diagnosticLineInfo')<CR>

" ============================================================================
" Navigation
" ============================================================================

" Next/Prev reference (LazyVim: ]]/[[)
nmap <silent> ]] <Plug>(coc-diagnostic-next)
nmap <silent> [[ <Plug>(coc-diagnostic-prev)

" Jump to next/prev placeholder
nnoremap <silent> ]c :call CocAction('diagnosticNext')<CR>
nnoremap <silent> [c :call CocAction('diagnosticPrevious')<CR>

" ============================================================================
" Float Window Scroll
" ============================================================================

nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" ============================================================================
" Snippets
" ============================================================================

" Use <C-l> for trigger snippet expand
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump
imap <C-j> <Plug>(coc-snippets-expand-jump)
