" Required
set nocompatible

" Dein plugin manager
let g:dein_dir = expand('~/.config/nvim/dein')
let g:dein_plugin_dir = expand('~/.config/nvim/dein_plugins')

exec 'set runtimepath+='.g:dein_dir

if dein#load_state(g:dein_plugin_dir)
    call dein#begin(g:dein_plugin_dir)

    call dein#add(g:dein_dir)

    " Airline
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')

    " Git integration
    call dein#add('tpope/vim-fugitive')

    " Colorschemes
    call dein#add('tomasr/molokai')
    call dein#add('sjl/badwolf')
    call dein#add('chriskempson/base16-vim')
    call dein#add('morhetz/gruvbox')

    " Highlighting
    call dein#add('tikhomirov/vim-glsl')
    call dein#add('bronson/vim-trailing-whitespace')

    call dein#end()
    call dein#save_state()
endif

if dein#check_install()
    call dein#install()
endif

filetype plugin indent on
syntax enable

" Colorscheme
set termguicolors
set background=dark
colorscheme base16-bright

" Airline
set laststatus=2
set noshowmode
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_min_count=2
let g:airline_skip_empty_sections=1
let g:airline_theme='base16_bright'
set ttimeoutlen=10

" Tabs
autocmd FileType html :setlocal sw=2 ts=2 sts=2
autocmd FileType make :setlocal sw=8 ts=8 sts=8 noexpandtab
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Visual Preferences
set lazyredraw
set number
set relativenumber
set numberwidth=2
set scrolloff=8
set cursorline
set colorcolumn=80
set title

" Misc.
set hidden

" Searches
set hlsearch
set incsearch
set ignorecase
set smartcase

" Bindings
let mapleader=","
noremap <C-n> :bnext<cr>
noremap <C-p> :bprevious<cr>
noremap <silent> <leader>/ :nohlsearch<cr>
