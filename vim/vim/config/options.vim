" ============================================================================
" Options - General Settings
" ============================================================================

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" Enable syntax and file type
syntax on
filetype plugin indent on

" Line numbers
set number
set relativenumber

" Cursorline
set cursorline

" Show matching brackets
set showmatch

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Indentation (2 spaces like nvim config)
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent
set copyindent

" Line wrapping
set wrap
set linebreak
set breakindent

" Show whitespace
set list
set listchars=tab:→\ ,trail:·,nbsp:␣

" Mouse support
set mouse=a

" Clipboard
set clipboard=unnamedplus

" Faster updatetime
set updatetime=300

" Short messages
set shortmess+=c

" True colors
if has('termguicolors')
  set termguicolors
endif

" Hidden buffers
set hidden

" Backup/Undo/Swap directories
set backup
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undofile
set undodir=~/.vim/undo//

" Create directories if missing
if !isdirectory(&backupdir) | call mkdir(&backupdir, 'p') | endif
if !isdirectory(&directory) | call mkdir(&directory, 'p') | endif
if !isdirectory(&undodir) | call mkdir(&undodir, 'p') | endif

" Folding
set foldmethod=indent
set foldlevelstart=99

" Split directions
set splitbelow
set splitright

" Timeout for key sequences
set timeout
set timeoutlen=300

" Disable default mode indicator (lightline handles it)
set noshowmode

" Wildmenu
set wildmenu
set wildmode=longest:full,full
set wildignore+=*/node_modules/*,*/.git/*,*/dist/*,*/build/*
