" ============================================================================
" FZF Configuration (LazyVim Snacks Picker Style)
" ============================================================================

" ============================================================================
" Main Pickers
" ============================================================================

nnoremap <silent> <leader><space> :Files<CR>
nnoremap <silent> <leader>, :Buffers<CR>
nnoremap <silent> <leader>/ :Rg<CR>
nnoremap <silent> <leader>: :Commands<CR>

" ============================================================================
" Find
" ============================================================================

nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fB :Buffers!<CR>
nnoremap <silent> <leader>fc :Files ~/.config<CR>
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fF :execute 'Files' getcwd()<CR>
nnoremap <silent> <leader>fg :GFiles<CR>
nnoremap <silent> <leader>fG :GFiles?<CR>
nnoremap <silent> <leader>fr :History<CR>
nnoremap <silent> <leader>fR :History<CR>
nnoremap <silent> <leader>fn :enew<CR>

" ============================================================================
" Search
" ============================================================================

nnoremap <silent> <leader>s" :Registers<CR>
nnoremap <silent> <leader>s/ :History/<CR>
nnoremap <silent> <leader>sa :Autocmds<CR>
nnoremap <silent> <leader>sb :BLines<CR>
nnoremap <silent> <leader>sB :Lines<CR>
nnoremap <silent> <leader>sc :History:<CR>
nnoremap <silent> <leader>sC :Commands<CR>
nnoremap <silent> <leader>sd :CocList diagnostics<CR>
nnoremap <silent> <leader>sD :CocList diagnostics --current-buffer<CR>
nnoremap <silent> <leader>sg :Rg<CR>
nnoremap <silent> <leader>sG :Rg<Space>
nnoremap <silent> <leader>sh :Helptags<CR>
nnoremap <silent> <leader>sH :Highlights<CR>
nnoremap <silent> <leader>si :CocList<CR>
nnoremap <silent> <leader>sj :Jumps<CR>
nnoremap <silent> <leader>sk :Maps<CR>
nnoremap <silent> <leader>sl :CocList locationlist<CR>
nnoremap <silent> <leader>sm :Marks<CR>
nnoremap <silent> <leader>sM :Man<CR>
nnoremap <silent> <leader>sp :Files<CR>
nnoremap <silent> <leader>sq :CocList quickfix<CR>
nnoremap <silent> <leader>sR :CocListResume<CR>
nnoremap <silent> <leader>su :MundoShow<CR>

" Search word under cursor
nnoremap <silent> <leader>sw :Rg <C-r><C-w><CR>
nnoremap <silent> <leader>sW :Rg <C-r><C-w><Space>
xnoremap <silent> <leader>sw y:Rg <C-r>"<CR>
xnoremap <silent> <leader>sW y:Rg <C-r>"<Space>

" ============================================================================
" FZF Layout
" ============================================================================

let g:fzf_layout = { 'down': '40%' }

" FZF preview window
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" ============================================================================
" FZF Commands
" ============================================================================

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
