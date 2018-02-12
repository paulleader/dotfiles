" Leader
let mapleader = " "

set nocompatible  " No vi compatibility required
set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch nohlsearch " do incremental searching without residual highlighting
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set smartcase     " Case insensitive searches, until an uppercase letter is typed

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g "" -v "^doc"'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " Also set up ag for Ack.vim
  let g:ackprg = "ag --vimgrep"
endif

" Configure Ctrl-n to toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

" Numbers
set number
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

autocmd FileType ruby map <silent> <leader>s :TestNearest<CR>
autocmd FileType ruby map <silent> <leader>t :TestFile<CR>
autocmd FileType ruby map <silent> <leader>l :TestLast<CR>
autocmd FileType ruby map <silent> <leader>g :TestVisit<CR>

autocmd FileType python map <silent> <leader>s :TestNearest<CR>
autocmd FileType python map <silent> <leader>t :TestFile<CR>
autocmd FileType python map <silent> <leader>l :TestLast<CR>
autocmd FileType python map <silent> <leader>g :TestVisit<CR>

let test#strategy = "tslime"
let g:test#preserve_screen = 1

let test#ruby#rspec#options = {
  \ 'nearest': '--fail-fast',
  \ 'file':    '--fail-fast',
  \ 'suite':   '--fail-fast',
\}

" By default assume that we want to target the current window in the current
" session for tslime commands, like test runs

let g:tslime_always_current_session=1
let g:tslime_always_current_window=1
let g:tmux_panenumber=2

" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>

" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>

" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>

" Zoom the tmux runner pane
map <Leader>vz :VimuxZoomRunner<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_eruby_ruby_quiet_messages =
    \ {"regex": "possibly useless use of a variable in void context"}

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Relative line numbering
set relativenumber

" Two settings to (potentially) aid in keeping the UI responsive, e.g. when
" scrolling
set ttyfast
set lazyredraw

" Colour scheme
let g:molokai_original=0
let g:rehash256 = 1
colorscheme molokai

" Highlight column 80

highlight ColorColumn ctermbg=235 guibg=#2c2d27
let &colorcolumn="80,80"

" Ruby mode for .thor and .etl files
au BufRead,BufNewFile *.thor set filetype=ruby
au BufNewFile,BufRead *.etl set filetype=ruby
au BufNewFile,BufRead *.jbuilder set filetype=ruby
au BufNewFile,BufRead *.axlsx set filetype=ruby

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" jk in rapid succession will bring you out of insert mode
inoremap jk <esc>
inoremap kj <esc>

cnoremap jk <c-c>
cnoremap kj <c-c>

vnoremap v <esc>

" Quick save shortcut
noremap <Leader>f :update<CR>

" Quick tab switching
nnoremap H gT
nnoremap L gt

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Start in hard mode by default
" autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()

" Toggle hard mode
nnoremap <leader>h <Esc>:call ToggleHardMode()<CR>

" Set up Seeeing is Believing
let g:xmpfilter_cmd = "seeing_is_believing"

autocmd FileType ruby nmap <buffer> <leader>m <Plug>(seeing_is_believing-mark)
autocmd FileType ruby xmap <buffer> <leader>m <Plug>(seeing_is_believing-mark)

autocmd FileType ruby nmap <buffer> <leader>c <Plug>(seeing_is_believing-clean)
autocmd FileType ruby xmap <buffer> <leader>c <Plug>(seeing_is_believing-clean)

autocmd FileType ruby nmap <buffer> <leader>r <Plug>(seeing_is_believing-run)
autocmd FileType ruby xmap <buffer> <leader>r <Plug>(seeing_is_believing-run)

" Configure custom shortcuts for moving between git hunks
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

let g:gitgutter_updatetime = 250

map y <Plug>(highlightedyank)

" taskwiki configuration
let g:taskwiki_sort_orders={"D": "description+"}

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
