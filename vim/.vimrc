" Basic settings
syntax enable               " Enable syntax highlighting
set number                  " Show line numbers
set relativenumber          " Show relative line numbers
set linebreak               " Break lines at word
set showbreak=+++           " Wrap-broken line prefix
set textwidth=100           " Line wrap (number of cols)
set showmatch               " Highlight matching brace
set visualbell              " Use visual bell (no beeping)
set hlsearch                " Highlight all search results
set smartcase               " Enable smart-case search
set ignorecase              " Always case-insensitive
set incsearch               " Searches for strings incrementally
set autoindent              " Auto-indent new lines
set expandtab               " Use spaces instead of tabs
set shiftwidth=4            " Number of auto-indent spaces
set smartindent             " Enable smart-indent
set smarttab                " Enable smart-tabs
set softtabstop=4           " Number of spaces per Tab
set ruler                   " Show row and column ruler information
set undolevels=1000         " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour
set wildmenu                " Enhanced command line completion
set wildmode=list:longest   " Complete files like a shell
set laststatus=2            " Always show status line
set confirm                 " Prompt to save before closing
set nobackup                " No backup files
set nowritebackup           " No backup files
set noswapfile              " No swap files
set mouse=a                 " Enable mouse usage in all modes
set clipboard=unnamed       " Use system clipboard
set encoding=utf-8          " Use UTF-8 encoding

" Key mappings
let mapleader = ","         " Set leader key to comma
inoremap jk <esc>           " Map jk to escape
nnoremap <leader>w :w<CR>   " Quick save
nnoremap <C-j> <C-W>j       " Navigate windows with ctrl+j
nnoremap <C-k> <C-W>k       " Navigate windows with ctrl+k
nnoremap <C-h> <C-W>h       " Navigate windows with ctrl+h
nnoremap <C-l> <C-W>l       " Navigate windows with ctrl+l
nnoremap <leader>q :q<CR>   " Quick quit
nnoremap <leader>/ :noh<CR> " Clear search highlights

" Colors
set background=dark
if has('termguicolors')
    set termguicolors
endif

" Source local settings if available
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
