call plug#begin('~/.local/share/nvim/plugged')
"Aesthetic stuff
	"fancy statusline and themes
	Plug 'vim-airline/vim-airline'
		Plug 'vim-airline/vim-airline-themes'
			let g:airline_powerline_fonts = 1
			let g:airline_theme = 'gruvbox'
	"vim theme
	Plug 'morhetz/gruvbox'
		let g:gruvbox_italic = '1'
"misc stuff
	"surround stuff with things
	Plug 'tpope/vim-surround'
"programming-related
	"comment out with gc
	Plug 'tpope/vim-commentary'
	Plug 'PotatoesMaster/i3-vim-syntax'
	Plug 'DaeZak/crafttweaker-vim-highlighting'
	Plug 'SirVer/ultisnips'
		let g:UltiSnipsExpandTrigger = '<tab>'
		let g:UltiSnipsJumpForwardTrigger = '<tab>'
		let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
		let g:UltiSnipsEditSplit = 'vertical'
		let g:UltiSnipsEnableSnipMate = 0
		let g:UltiSnipsUsePythonVersion = 3
		cmap use UltiSnipsEdit
	" Plug 'w0rp/ale'	"Linting engine and lsp client
		" let g:airline#extensions#ale#enabled = 1
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'preservim/nerdtree'

	Plug 'puremourning/vimspector'
	Plug 'tpope/vim-fugitive'
	Plug 'nvim-lua/popup.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope-fzy-native.nvim'
	Plug 'kyazdani42/nvim-web-devicons'
	Plug 'rust-lang/rust.vim'

	Plug 'plasticboy/vim-markdown'
	" UML:
	Plug 'aklt/plantuml-syntax'
	Plug 'weirongxu/plantuml-previewer.vim'
	Plug 'tyru/open-browser.vim'
	call plug#end()

"basic stuff
"line numbers and relative line numbers
	set number
	set relativenumber
"automatic saving after every change
	set autowriteall
"read if file is changed externally
	set autoread
	set nosol
	syntax on
	filetype plugin indent on
	set encoding=utf-8
	colorscheme gruvbox "colourscheme
	set scrolloff=5
	set nohlsearch
	set noshowmode 			" showing the mode is redundant with airline
	set tabstop=4
	set softtabstop=4
	set cursorcolumn
	nnoremap j gj
	nnoremap k gk
	set shiftwidth=4
	let mapleader = " "
	let leader = ","
	nnoremap Q <nop> 		" avoid switching to ex mode
	noremap Y y$			" consistency
	set wildmenu
	set wildmode=longest,list,full	" autocompletion
	"disable automatic commenting on newline
	au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
	set splitbelow splitright	"splits open to the bottom and right"
	set termguicolors
	set background=dark
	"Always show the signs column
	set signcolumn=yes
	"shorten update times
	set updatetime=300
	nnoremap c "_c
	set linebreak
	set guifont=Liberation\ Mono:h12
"guide navigation
	nnoremap <leader><leader><space> /<+x+><CR>cf>
	inoremap <leader><leader><space> <Esc>/<+x+><CR>cf>
	nnoremap <leader><leader>i<space> a<+x+><Esc>
	inoremap <leader><leader>i<space> <+x+>


"Plugin configuration
	"nerdtree
		nnoremap <leader>a :NERDTreeToggle<cr>
	"coc.nvim
		nmap <leader>rn <Plug>(coc-rename)

"copying and pasting from system clipboard.
	 vnoremap <C-c> "+y
	 "nmap <C-w> "+P

au BufWritePre * %s/\s\+$//e "delete trailing whitespace on write
au BufWritePre * %s/\n\+\%$//e "delete newlines at the end of file on write

"automatically make files containing shebang executable
	fu MakeScriptsExecutable()
		if getline(1) =~ "^#!"
			silent !chmod x %:p
		endif
	endfu

	au BufWritePost * call MakeScriptsExecutable()


"split movement
	cmap tsp :sp +te
	cmap vts :vs +te
	nnoremap <C-h> <C-w>h
	nnoremap <C-j> <C-w>j
	nnoremap <C-k> <C-w>k
	nnoremap <C-l> <C-w>l
	nnoremap <M-x> <C-w>x
	nnoremap <M-r> <C-w>r
	nnoremap <M-h> <C-w>H
	nnoremap <M-j> <C-w>J
	nnoremap <M-k> <C-w>K
	nnoremap <M-l> <C-w>L

"block arrow keys to force me to not use them
	nnoremap <up> <nop>
	nnoremap <down> <nop>
	nnoremap <left> <nop>
	nnoremap <right> <nop>
	inoremap <up> <nop>
	inoremap <down> <nop>
	inoremap <left> <nop>
	inoremap <right> <nop>
	vnoremap <up> <nop>
	vnoremap <down> <nop>
	vnoremap <left> <nop>
	vnoremap <right> <nop>

"firenvim
	let g:firenvim_config = {
		\ 'globalSettings': {
			\ 'alt': 'all',
		\  },
		\ 'localSettings': {
			\ '.*': {
				\ 'cmdline': 'firenvim',
				\ 'priority': 0,
				\ 'selector': 'textarea',
				\ 'takeover': 'never',
			\ },
		\ }
	\ }
"telescope:
	" Find files using Telescope command-line sugar.
	nnoremap <leader>ff <cmd>Telescope find_files<cr>
	nnoremap <leader>fg <cmd>Telescope live_grep<cr>
	nnoremap <leader>fb <cmd>Telescope buffers<cr>
	nnoremap <leader>fc <cmd>Telescope command_history<cr>
"fugitive
	nnoremap <leader>gs <cmd>G<cr>
	nnoremap <leader>gj <cmd>diffget //3<cr>
	nnoremap <leader>gf <cmd>diffget //2<cr>

set diffopt+=vertical
let g:rustfmt_autosave = 1

function! Formatonsave()
  let l:formatdiff = 1
  pyf /usr/share/clang/clang-format.py
endfunction

autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()

"Cosas del Coc Para usar con cpp:
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup


" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
