" load plugins as required
execute pathogen#infect()

" common settings {{{1
" visual effects {{{2
syntax enable

" automatic indentation
set autoindent

set nowrap

" tabbing rules
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

" highlight wide line
let &colorcolumn=join(range(81,999), ',')

" viewing options
set scrolloff=3
set encoding=utf-8
set spelllang=en,nl
set splitbelow
set splitright
set number
set relativenumber
set laststatus=2

" search options
set hlsearch             " highlight search results
set incsearch            " highlight while typing search
set ignorecase           " case insensitive
set smartcase            " except when using capital letters

" other {{{2
" store all meta files in vim directory
if $MYVIMRC[0] ==# '/'
    let s:vimdir='/'.join(split($MYVIMRC, '/\|\\')[0:-2], '/')
else
    let s:vimdir=join(split($MYVIMRC, '/\|\\')[0:-2], '/')
endif
execute('set backupdir='.s:vimdir.'/.backup/')
execute('set directory='.s:vimdir.'/.swap/')
execute('set undodir='.s:vimdir.'/.undo/')

" make backspace behave
set backspace=2

" filetype detection
filetype plugin indent on

" use system clipboard
set clipboard=unnamed

" automatically reload
set autoread

" tab completion of commands
set wildmenu
set wildmode=list:longest,full

" set <c-n> completion
set completeopt=longest,menu

" keep undo history in file
set undofile

" environment dependent settings {{{1
" set color theme
colorscheme solarized
if has('gui_running')
    " gvim
    set background=light
    set guifont=Hack:h10:cANSI
else
    " vim
    set background=dark
endif

" plugin settings {{{1
" Airline {{{2
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" CtrlP {{{2
" set command to open
let g:ctrlp_map = '<Space>p'
let g:ctrlp_cmd = 'CtrlPMixed'

" set cache directory
let g:ctrlp_cache_dir = $HOME.'/vimfiles/.cache/ctrlp'

" ask how to open new file
let g:ctrlp_arg_map = 1

" follow non-looping symlinks
let g:ctrlp_follow_symlinks = 1

" persistent cache
let g:ctrlp_clear_cache_on_exit = 0

" use silver searcher if possible and exclude listed filetypes
if executable('ag')
    let g:ctrlp_user_command = 'ag --nocolor -g "^((?!\.(aux|auxlock|pdf|vc|log|synctex\.gz|bbl|blg|dep|dpth|md5)$).)*$" %s'
endif

" Fugitive {{{2
nnoremap <leader>W :Gwrite<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gs :Gstatus<cr>

" Syntastic {{{2
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0

" commands {{{1
" remove trailing whitespace
command! RemoveTrailingSpace call pvs#removetrailingspace()

" global mappings {{{1
" use space as leader
nnoremap <space> <nop>
let mapleader=' '
let maplocalleader=' '

" move display line
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" move between windows
nnoremap <c-j> :wincmd j<cr>
nnoremap <c-k> :wincmd k<cr>
nnoremap <c-l> :wincmd l<cr>
nnoremap <c-h> :wincmd h<cr>
nnoremap <c-w><c-w> :wincmd p<cr>

" make Y sane
nnoremap Y y$

" sane regexes
nnoremap / /\v
vnoremap / /\v

" make jumping sane
nnoremap ` '
nnoremap ' `

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv


nnoremap <leader>w :write<cr>

" wrapping options
nnoremap <leader>tw :set wrap!<bar>:call pvs#updatewrap()<cr>
nnoremap ZZ :write<cr>:call pvs#softwrapclose()<cr>:wincmd q<cr>
nnoremap ZQ :call pvs#softwrapclose()<cr>:wincmd q<cr>

" easy editing
nnoremap <F12> :new<cr>:edit $MYVIMRC<cr>
nnoremap <leader>ed :edit<space>

" select last edit
nnoremap gl `[v`]

" change case of symbols
nnoremap ~ :call pvs#changecase()<cr>

" open temporary buffer
nnoremap <leader>t :call pvs#opentemporarybuffer()<cr>

" remove trailing whitespact
nnoremap <leader>rts :call pvs#removetrailingspace()<cr>

" increment counter on subsequent lines
nnoremap <leader><c-a> :call pvs#incrementsubsequentlines()<cr>

" map in( etc to next brace {{{2
onoremap in( :call pvs#selectclosestbracket('(', 'i(')<cr>
onoremap in) :call pvs#selectclosestbracket('(', 'i)')<cr>
onoremap inb :call pvs#selectclosestbracket('(', 'ib')<cr>
onoremap in{ :call pvs#selectclosestbracket('{', 'i{')<cr>
onoremap in} :call pvs#selectclosestbracket('{', 'i}')<cr>
onoremap inB :call pvs#selectclosestbracket('{', 'iB')<cr>
onoremap in[ :call pvs#selectclosestbracket('[', 'i[')<cr>
onoremap in] :call pvs#selectclosestbracket('[', 'i]')<cr>
onoremap in< :call pvs#selectclosestbracket('<', 'i<')<cr>
onoremap in> :call pvs#selectclosestbracket('<', 'i>')<cr>
onoremap an( :call pvs#selectclosestbracket('(', 'a(')<cr>
onoremap an) :call pvs#selectclosestbracket('(', 'a)')<cr>
onoremap anb :call pvs#selectclosestbracket('(', 'ab')<cr>
onoremap an{ :call pvs#selectclosestbracket('{', 'a{')<cr>
onoremap an} :call pvs#selectclosestbracket('{', 'a}')<cr>
onoremap anB :call pvs#selectclosestbracket('{', 'aB')<cr>
onoremap an[ :call pvs#selectclosestbracket('[', 'a[')<cr>
onoremap an] :call pvs#selectclosestbracket('[', 'a]')<cr>
onoremap an< :call pvs#selectclosestbracket('<', 'a<')<cr>
onoremap an> :call pvs#selectclosestbracket('<', 'a>')<cr>

