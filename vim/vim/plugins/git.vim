" ============================================================================
" Git Configuration
" ============================================================================

" ============================================================================
" Fugitive Keymaps
" ============================================================================

nnoremap <silent> <leader>gg :Git<CR>
nnoremap <silent> <leader>gS :Git status<CR>
nnoremap <silent> <leader>gs :Git status<CR>
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gd :Git diff<CR>
nnoremap <silent> <leader>gD :Git diff HEAD<CR>
nnoremap <silent> <leader>gL :Git log<CR>
nnoremap <silent> <leader>gl :Git log --oneline<CR>
nnoremap <silent> <leader>gf :GFiles?<CR>
nnoremap <silent> <leader>gF :Git fetch<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gP :Git pull<CR>

" ============================================================================
" GitGutter Configuration
" ============================================================================

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '‾'
let g:gitgutter_sign_modified_removed = '~-'
let g:gitgutter_map_keys = 0
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1

" Hunk navigation
nnoremap <silent> ]h :GitGutterNextHunk<CR>
nnoremap <silent> [h :GitGutterPrevHunk<CR>

" Hunk preview
nnoremap <silent> <leader>hp :GitGutterPreviewHunk<CR>

" Stage/undo hunk
nnoremap <silent> <leader>hs :GitGutterStageHunk<CR>
nnoremap <silent> <leader>hu :GitGutterUndoHunk<CR>

" Highlight lines
nnoremap <silent> <leader>gh :GitGutterLineHighlightsToggle<CR>

" ============================================================================
" Git Conflict Markers
" ============================================================================

" Jump to next/prev conflict
nnoremap <silent> ]c :GitGutterNextHunk<CR>
nnoremap <silent> [c :GitGutterPrevHunk<CR>
