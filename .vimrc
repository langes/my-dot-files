" BASIC SETUP:


" Enter the current millenium
set nocompatible

" Disable beeping
set noerrorbells


" Enable systax and plugins (for netrw)
syntax on
filetype plugin indent on


" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %


" Better copy & paste
" When you want to paste large blocks of code into vim, press F2 before you
" paste. At the bottom you should see ``-- INSERT (paste) --``.
set pastetoggle=<F2>
"" set clipboard=unnamed


" Mouse
set mouse=r     " on OSX press ALT and click


" Rebind <Leader> key
" I like to have it here becuase it is easier to reach than the default and
" it is next to ``m`` and ``n`` which I use for navigating between tabs.
let mapleader = ","


" Showing line numbers and length
set number  " show line numbers
set tw=79   " width of document (used by gd)
set nowrap  " don't show autoamtically wrap on load
set fo-=t   " don't automatically wrap text when typing
set colorcolumn=80


" Highlight current line
set cursorline


" Set tab settings:
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" More natural split opening
set splitbelow
set splitright
 
" Easier split navigations
" So instead of ctrl-w then j, it’s just ctrl-j:
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" Set history and undo settings:
set history=700
set undolevels=700


" Show whitespace
" MUST be inserted BEFORE the colorscheme command
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/


" Color scheme
" mkdir -p ~/.vim/colors && cd ~/.vim/colors
" wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400
set t_Co=256
" color wombat256mod
color solarized
set background=dark


" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase


" easier moving between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>




" FINDING FILES:


" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**


" Display all matching files when we tab complete
set wildmenu

" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy

" THINGS TO CONSIDER:
" - :b lets you autocomplete any open buffer




" TAG JUMPING:


" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .

" NOW WE CAN:
" - Use ^] to jump to tag under cursor
" - Use g^] for ambiguous tags
" - Use ^t to jump back up the tag stack

" THINGS TO CONSIDER:
" - This doesn't help if you want a visual list of tags




" AUTOCOMPLETE:


" The good stuff is documented in |ins-completion|

" HIGHLIGHTS:
" - ^x^n for JUST this file
" - ^x^f for filenames (works with our path trick!)
" - ^x^] for tags only
" - ^n for anything specified by the 'complete' option

" NOW WE CAN:
" - Use ^n and ^p to go back and forth in the suggestion list




" FILE BROWSING:

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" NOW WE CAN:
" - :edit a folder to open a file browser
" - <CR>/v/t to open in an h-split/v-split/tab
" - check |netrw-browse-maps| for more mappings




" PLUGIN SECTION:

" Setup vim-plug
call plug#begin('~/.vim/plugged')

Plug 'davidhalter/jedi-vim'
Plug 'Lokaltog/vim-powerline'
Plug 'mkitt/tabline.vim'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'Shougo/neocomplete.vim'
Plug 'hashivim/vim-terraform'
Plug 'baverman/vial'
Plug 'baverman/vial-http'

call plug#end()

" Setup Pathogen to manage your plugins
" mkdir -p ~/.vim/autoload ~/.vim/bundle
" curl -so ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
" Now you can install any plugin into a .vim/bundle/plugin-name/ folder
"call pathogen#infect()

" Settings for vim-powerline
" cd ~/.vim/bundle
" git clone git://github.com/Lokaltog/vim-powerline.git
set laststatus=2


" Settings for jedi-vim
" You need to install the pyhton module jedi for this!
" sudo pip install jedi
" cd ~/.vim/bundle
" git clone git://github.com/davidhalter/jedi-vim.git
let g:jedi#usages_command = "<leader>z"
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>


" Python folding
" mkdir -p ~/.vim/ftplugin
" wget -O ~/.vim/ftplugin/python_editing.vim http://www.vim.org/scripts/download_script.php?src_id=5492
set nofoldenable


" Tabline
" cd ~/.vim/bundle
" git clone git://github.com/mkitt/tabline.vim.git
let g:tablineclosebutton=1


" vim-go settings and shortcuts
let g:go_list_type = "quickfix" "Use only one type of lists
let g:go_test_timeout = '10s'
let g:go_fmt_command = "goimports"
let g:go_auto_sameids = 1

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>

" autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <Leader>i <Plug>(go-info)
" autocmd FileType go set autowrite


" Activate neocomplete
let g:neocomplete#enable_at_startup = 1
set completeopt-=preview " disable preview " disable


" terraform plugin
let g:terraform_align=1 " terraform indent
let g:terraform_fold_sections=1 " allow plugin to fold and unfold resources
let g:terraform_remap_spacebar=1 " map unfold / fold to space


" vim folding
set foldmethod=syntax
" set foldlevel=1
set foldclose=all
