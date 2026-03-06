" ============================================================================
" Keymaps - LazyVim Style
" ============================================================================

" ============================================================================
" Custom Keymaps (Matching Neovim Config)
" ============================================================================

" Exit insert mode with jk
inoremap jk <Esc>

" Exit visual mode with q
xnoremap q <Esc>

" Move selected lines up/down
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

" Join lines without cursor jump
nnoremap J mzJ`z

" Paste without overwriting register
xnoremap p "_dP

" Delete character without copying
nnoremap x "_x

" Escape and clear hlsearch (LazyVim: <esc> clears hlsearch in normal mode)
nnoremap <silent> <Esc> :nohlsearch<CR>

" Save file (LazyVim: <C-s>)
nnoremap <silent> <C-s> :write<CR>
inoremap <silent> <C-s> <Esc>:write<CR>
xnoremap <silent> <C-s> <Esc>:write<CR>

" Keywordprg (LazyVim: <leader>K)
nnoremap <leader>K :execute '!'.&keywordprg.' '.expand('<cword>')<CR>

" Redraw / Clear hlsearch (LazyVim: <leader>ur)
nnoremap <leader>ur :nohlsearch<Bar>diffupdate<CR>:echo 'Cleared hlsearch'<CR>

" New File (LazyVim: <leader>fn)
nnoremap <leader>fn :enew<CR>

" ============================================================================
" Better Search Navigation (LazyVim Style)
" ============================================================================

" Center search results
nnoremap n nzzzv
nnoremap N Nzzzv
xnoremap n nzzzv
xnoremap N Nzzzv

" ============================================================================
" Move Lines (LazyVim: Alt-j/k)
" ============================================================================

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" ============================================================================
" Buffers (LazyVim Style)
" ============================================================================

nnoremap <S-h> :bprevious<CR>
nnoremap <S-l> :bnext<CR>
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>
nnoremap <leader>bb :b#<CR>
nnoremap <leader>` :b#<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bo :%bdelete\|edit #<CR>
nnoremap <leader>bD :bdelete<CR>:close<CR>

" ============================================================================
" Windows (LazyVim Style)
" ============================================================================

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

nnoremap <silent> <leader>- :split<CR>
nnoremap <silent> <leader><Bar> :vsplit<CR>
nnoremap <leader>wd :close<CR>

" ============================================================================
" Tabs (LazyVim Style)
" ============================================================================

nnoremap <leader><Tab><Tab> :tabnew<CR>
nnoremap <leader><Tab>d :tabclose<CR>
nnoremap <leader><Tab>] :tabnext<CR>
nnoremap <leader><Tab>[ :tabprevious<CR>
nnoremap <leader><Tab>l :tablast<CR>
nnoremap <leader><Tab>f :tabfirst<CR>
nnoremap <leader><Tab>o :tabonly<CR>

" ============================================================================
" Quit (LazyVim Style)
" ============================================================================

nnoremap <leader>qq :qa<CR>

" ============================================================================
" Quickfix Navigation (LazyVim: [q / ]q)
" ============================================================================

nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>

" Location list
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>

" ============================================================================
" Terminal (for Neovim)
" ============================================================================

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
  nnoremap <leader>fT :terminal<CR>
  nnoremap <leader>ft :terminal<CR>
endif

" ============================================================================
" User Commands
" ============================================================================

command! -nargs=? -complete=dir VimChroot call VimChroot(<q-args>)

function! VimChroot(path)
  let l:path = a:path
  if l:path == ''
    let l:path = expand('%:p:h')
  endif
  if isdirectory(l:path)
    execute 'cd ' . fnameescape(l:path)
    echo 'Root switch to: ' . l:path
  else
    echoerr 'ERROR: Not a valid directory -> ' . l:path
  endif
endfunction
