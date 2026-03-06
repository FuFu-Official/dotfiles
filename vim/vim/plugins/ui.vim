" ============================================================================
" UI Configuration
" ============================================================================

" ============================================================================
" Colorscheme (matching nvim config: catppuccin, rose-pine)
" ============================================================================

" Catppuccin (mocha flavour - matches nvim config)
let g:catppuccin_flavour = 'mocha'
let g:disable_bg = 1
let g:disable_float_bg = 1

" Rose Pine (moon variant - matches nvim config)
let g:rose_pine_variant = 'moon'
let g:rose_pine_disable_background = 1
let g:rose_pine_disable_float_background = 1

" Set colorscheme (uncomment one)
" colorscheme catppuccin_mocha
colorscheme rosepine_moon

" ============================================================================
" Lightline Configuration (matching nvim lualine)
" ============================================================================

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'filetype', 'fileencoding' ] ],
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ] ],
      \ },
      \ 'tabline': {
      \   'left': [ [ 'tabs' ] ],
      \   'right': [ [ 'close' ] ],
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ },
      \ 'colorscheme': 'rosepine_moon',
      \ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root && root !=# ''
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

" ============================================================================
" NERDTree Configuration (LazyVim Explorer Style)
" ============================================================================

let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeIgnore = ['\.git$', '\.pyc$', '__pycache__', '\.swp$', '\.DS_Store', 'node_modules', '\.egg-info$']
let NERDTreeStatusline = ''
let NERDTreeWinSize = 35

nnoremap <silent> <leader>fe :NERDTreeToggle<CR>
nnoremap <silent> <leader>fE :NERDTreeFind<CR>
nnoremap <silent> <leader>e :NERDTreeToggle<CR>
nnoremap <silent> <leader>E :NERDTreeFind<CR>

" ============================================================================
" Smoothie Configuration
" ============================================================================

let g:smoothie_no_default_mappings = 0
let g:smoothie_update_interval = 10
let g:smoothie_base_speed = 5

" ============================================================================
" ScrollEOF (keep cursor away from edges - like nvim scrollEOF.nvim)
" ============================================================================

set scrolloff=4
set sidescrolloff=8

" ============================================================================
" Visual Settings
" ============================================================================

" Show cursor line only in active window
augroup CursorLine
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

" Show colorcolumn at textwidth
set colorcolumn=+1

" ============================================================================
" Toggle UI Elements (LazyVim Style)
" ============================================================================

" Toggle relative line numbers
nnoremap <leader>uL :set relativenumber!<CR>

" Toggle line numbers
nnoremap <leader>ul :set number!<CR>

" Toggle spell check
nnoremap <leader>us :set spell!<CR>

" Toggle wrap
nnoremap <leader>uw :set wrap!<CR>

" Toggle cursor column
nnoremap <leader>uc :let &cursorcolumn = !&cursorcolumn<CR>

" Toggle background (dark/light)
nnoremap <leader>ub :let &background = (&background == 'dark' ? 'light' : 'dark')<CR>

" Toggle diagnostics
nnoremap <leader>ud :call CocAction('diagnosticToggle')<CR>

" Toggle inlay hints
nnoremap <leader>uh :call CocAction('toggleInlayHint')<CR>

" Toggle conceal
nnoremap <leader>uC :let &conceallevel = (&conceallevel == 0 ? 2 : 0)<CR>

" Toggle auto format
nnoremap <leader>uf :call ToggleAutoFormat()<CR>

" ============================================================================
" Transparency (like nvim transparent.nvim)
" ============================================================================

let g:transparent_enabled = 0

function! ToggleTransparent()
  if g:transparent_enabled
    hi Normal guibg=NONE ctermbg=NONE
    hi NormalFloat guibg=NONE ctermbg=NONE
    hi FloatBorder guibg=NONE ctermbg=NONE
    hi LineNr guibg=NONE ctermbg=NONE
    hi SignColumn guibg=NONE ctermbg=NONE
    hi EndOfBuffer guibg=NONE ctermbg=NONE
    let g:transparent_enabled = 1
    echo 'Transparent enabled'
  else
    hi clear Normal
    hi clear NormalFloat
    hi clear FloatBorder
    hi clear LineNr
    hi clear SignColumn
    hi clear EndOfBuffer
    let g:transparent_enabled = 0
    echo 'Transparent disabled'
  endif
endfunction

nnoremap <leader>uT :call ToggleTransparent()<CR>
