" ============================================================================
" Editor Plugins Configuration
" ============================================================================

" ============================================================================
" Commentary (LazyVim uses gcc/gc, not <leader>/)
" ============================================================================

" vim-commentary default mappings:
" gcc - comment/uncomment line
" gc{motion} - comment/uncomment region
" gc in visual mode - comment/uncomment selection

" Add comment below/above (LazyVim: gco/gcO)
nnoremap <silent> gco :call AddCommentBelow()<CR>
nnoremap <silent> gcO :call AddCommentAbove()<CR>

function! AddCommentBelow()
  normal! o
  call feedkeys("\<Plug>Commentary")
endfunction

function! AddCommentAbove()
  normal! O
  call feedkeys("\<Plug>Commentary")
endfunction

" ============================================================================
" Surround (mini.surround Style)
" ============================================================================

" vim-surround uses: ys (add), ds (delete), cs (replace)
" Add mini.surround style keymaps (gsa/gsd/gsr)
nmap gsa ysiw
nmap gsd ds
nmap gsr cs
xmap gsa S

" ============================================================================
" Visual Multi (Multiple Cursors)
" ============================================================================

let g:vm_maps = {}
let g:vm_maps['Find Under'] = '<C-n>'
let g:vm_maps['Find Subword Under'] = '<C-n>'
let g:vm_maps['Select All'] = '<C-A-n>'
let g:vm_maps['Skip Region'] = '<C-x>'
let g:vm_maps['Remove Region'] = '<C-p>'

" ============================================================================
" Auto Format on Save
" ============================================================================

augroup FormatOnSave
  autocmd!
  autocmd BufWritePre *.lua,*.py,*.js,*.ts,*.json,*.css,*.html,*.md,*.c,*.cpp silent call CocAction('format')
augroup END

" Toggle auto format
let g:auto_format_enabled = 1

function! ToggleAutoFormat()
  if g:auto_format_enabled
    augroup FormatOnSave
      autocmd!
    augroup END
    let g:auto_format_enabled = 0
    echo 'Auto format disabled'
  else
    augroup FormatOnSave
      autocmd!
      autocmd BufWritePre *.lua,*.py,*.js,*.ts,*.json,*.css,*.html,*.md,*.c,*.cpp silent call CocAction('format')
    augroup END
    let g:auto_format_enabled = 1
    echo 'Auto format enabled'
  endif
endfunction

nnoremap <leader>uf :call ToggleAutoFormat()<CR>

" ============================================================================
" Trailing Whitespace
" ============================================================================

" Show trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=#ff5555
match ExtraWhitespace /\s\+$/

" Remove trailing whitespace on save
augroup TrimWhitespace
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END

" ============================================================================
" Better Paste
" ============================================================================

" Keep cursor position after paste
nnoremap <expr> p (p ==# 'p') ? 'p`]' : 'p'
nnoremap <expr> P (P ==# 'P') ? 'P`]' : 'P'
