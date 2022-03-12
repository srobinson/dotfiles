set nocompatible
set path+=**
set ai
syntax on
hi Normal guibg=NONE ctermbg=NONE

let g:python_host_prog = "$HOME/.pyenv/shims/python2.7"
let g:python3_host_prog = "$HOME/.pyenv/shims/python"
let g:perl_host_prog = "/usr/bin/perl"

autocmd! BufWritePost $HOME/.config/nvim/init.vim source %

call plug#begin()
Plug 'dense-analysis/ale'
Plug 'dhruvasagar/vim-open-url'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
" https://vi.stackexchange.com/questions/3728/how-can-i-work-with-splits-in-vim-without-ctrl-w
" https://github.com/kana/vim-submode/issues/32
" Plug 'Iron-E/nvim-libmodal'
Plug 'itchyny/lightline.vim'
Plug 'jdhao/better-escape.nvim'
Plug 'jparise/vim-graphql'
Plug 'hashivim/vim-terraform'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'numToStr/Comment.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'rottencandy/vimkubectl'
Plug 'ruanyl/vim-gh-line'
Plug 'sainnhe/gruvbox-material'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-obsession'
" Plug 'tribela/vim-transparent'
Plug 'williamboman/nvim-lsp-installer'
Plug 'unblevable/quick-scope'
call plug#end()

lua require('lsp')
lua require('gitsigns').setup()
lua require('Comment').setup()

set signcolumn=yes
set colorcolumn=120

nnoremap <leader>s :source ~/.config/nvim/init.vim <bar> :noh<CR>

let g:better_escape_shortcut = ['kj']
inoremap kj <esc>
inoremap <esc> <NOP>
vnoremap kj <esc>
" search will center on the line it's found on
nnoremap n nzzzv
nnoremap N Nzzzv

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" noremap h <NOP>
" noremap j <NOP>
" noremap k <NOP>
" noremap l <NOP>

nnoremap j gj
nnoremap k gk

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

set splitbelow
set splitright
set fillchars+=vert:\ 
set scrolloff=10

noremap <Space> 10j
noremap <C-Space> 10k
noremap ZX ZQ
noremap <C-s> :w<CR>

set termguicolors
set background=dark
" wait for plugins to load before using colorshceme
autocmd vimenter * ++nested colorscheme gruvbox-material
let g:lightline = {'colorscheme' : 'gruvbox_material'}
set noshowmode
if !has('gui_running')
  set t_Co=256
endif

set showcmd
set number
set relativenumber
set ruler
set cursorline
set list
set listchars=trail:·,space:·,precedes:«,extends:»,eol:¬,tab:▸· 
set incsearch hlsearch
map <silent> <esc> :noh <CR>
" nnoremap <silent> <leader><ESC> :noh<CR>

set ignorecase
set backspace=indent,eol,start
highlight Normal ctermbg=None
highlight LineNr ctermfg=DarkGrey

filetype plugin indent on
set expandtab
set smarttab
set cindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set nowrap

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set clipboard=unnamed
set clipboard+=unnamedplus

set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287

" mhinz/vim-signify: default updatetime 4000ms is not good for async update
set updatetime=100

" Scrolling relative to cursor
nnoremap <C-j> <C-E>
nnoremap <C-k> <C-Y>


" NERDTree
" Auto start NERD tree when opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | wincmd p | endif

" Auto start NERD tree if no files are specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | exe 'NERDTree' | endif

" Let quit work as expected if after entering :q the only window left open is NERD Tree itself
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif



" By default, Vim associates .tf files with TinyFugue - tell it not to.
silent! autocmd! filetypedetect BufRead,BufNewFile *.tf
autocmd BufRead,BufNewFile *.hcl set filetype=hcl
autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl
autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json

