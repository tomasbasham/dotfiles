set encoding=utf-8
scriptencoding utf-8

" ============ "
" === Plug === "
" ============ "

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'honza/vim-snippets'
Plug 'keith/swift.vim'
Plug 'lervag/vimtex'
Plug 'majutsushi/tagbar'
Plug 'mattn/webapi-vim'
Plug 'mileszs/ack.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'rust-lang/rust.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'thaerkh/vim-workspace'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rbenv'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-ruby/vim-ruby'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }

if has('mac')
  Plug 'junegunn/vim-xmark'
endif

" Load on nothing
Plug 'SirVer/ultisnips', { 'on': [] }
Plug 'Valloric/YouCompleteMe', { 'on': [] }

augroup load_us_ycm
  autocmd!
  autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
                     \| autocmd! load_us_ycm
augroup END

call plug#end()

" =============== "
" === General === "
" =============== "

set noswapfile " No swap file.
set noundofile " No undo file.

set modeline " support vim options in individual files with magic comments.

" preserve the native leader keys.
nmap , \
vmap , \

nmap <space> \
vmap <space> \

" shift-C changes till the end of line, and shift-D deletes till the of the
" line. shift-Y breaks the pattern, and it's an alias for `yy'. This was
" initially in vim-sensible but then removed.
nnoremap Y y$

" Delete without yanking, send the deleted content to the 'black hole' register.
" https://stackoverflow.com/questions/7501092/can-i-map-alt-key-in-vim
" http://vim.wikia.com/wiki/Get_Alt_key_to_work_in_terminal
if !has('nvim')
  set <M-d>=d
end

" ...then, the actual mapping:
" current line in normal and insert mode
nnoremap <M-d> "_dd
nnoremap <Leader>d "_dd
" selection in visual mode
vnoremap <M-d> "_d
vnoremap <Leader>d "_d

set pastetoggle=<F3>

" --- Paste over visual selection preserving the content of the paste buffer
" p   -> paste normally
" gv  -> reselect the pasted text
" y   -> copy it again
" `>  -> jump to the last character of the visual selection (built-in mark)
vnoremap <Leader>p pgvy`>

" Move lines up and down with Ctrl-arrowup/down and Ctrl-j/k (in normal, visual and insert mode)
" Note: only meant for small selections and small movements, will break moving
" multiple lines down beyond the bottom.
nnoremap <C-Down> :m .+1<CR>
nnoremap <C-Up> :m .-2<CR>
vnoremap <C-Down> :m '>+1<CR>gv
vnoremap <C-Up> :m '<-2<CR>gv
inoremap <C-Down> <ESC>:m .+1<CR>gi
inoremap <C-Up> <ESC>:m .-2<CR>gi
" For terminals where Ctrl-arrows are captured by the system.
nnoremap <C-j> :m .+1<CR>
nnoremap <C-k> :m .-2<CR>
vnoremap <C-j> :m '>+1<CR>gv
vnoremap <C-k> :m '<-2<CR>gv
inoremap <C-j> <ESC>:m .+1<CR>gi
inoremap <C-k> <ESC>:m .-2<CR>gi

" ====================== "
" === Buffer Options === "
" ====================== "

" Reuse buffers: if a buffer is already open in another window, jump to it
" instead of opening a new window.
set switchbuf=useopen

" Allow to open a different buffer in the same window of a modified buffer
set hidden

" position of the new split panes
set splitbelow
set splitright

" Close the current buffer without closing the window
" <http://stackoverflow.com/a/8585343/417375>
nnoremap <Leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" =================== "
" === Colorscheme === "
" =================== "

" colorscheme agnostic

" Try to use 'peachpuff' if available, because it's adapts to dark and light
" " background terminals, at the same time, which is useful for pairing.
try
  colorscheme peachpuff
catch
  echom "'peachpuff' colorscheme not available, defaulting to 'default'"
  try
    colorscheme default
  catch
    echom "'default' colorscheme not available, not setting the colorscheme"
  endtry
endtry

" autocmd ColorScheme * highlight Normal       ctermfg=7  ctermbg=0
" autocmd ColorScheme * highlight Comment      ctermfg=3  ctermbg=0 cterm=none term=none
" autocmd ColorScheme * highlight Search       ctermbg=11 ctermfg=0
" autocmd ColorScheme * highlight StatusLine   ctermbg=3  ctermfg=0 cterm=none
" autocmd ColorScheme * highlight StatusLineNC ctermbg=0  ctermfg=7
" autocmd ColorScheme * highlight ErrorMsg     ctermbg=9  ctermfg=8
" autocmd ColorScheme * highlight ModeMsg      ctermbg=10 ctermfg=0
" autocmd ColorScheme * highlight MoreMsg      ctermbg=11 ctermfg=8
" autocmd ColorScheme * highlight Question     ctermbg=13 ctermfg=0 cterm=none
" autocmd ColorScheme * highlight VertSplit    ctermbg=7  ctermfg=7

" slightly more workable search highlighting for default ubuntu theme
" 5 = magenta, 7 = white
highlight Search term=reverse cterm=NONE ctermbg=5 ctermfg=7
" highlight Search term=reverse cterm=reverse ctermbg=8 ctermfg=3

" ========================== "
" === Completion Options === "
" ========================== "

set wildmode=list:longest,full " Open a list of all the matches (list) *and* cycle through them (full)
set wildignorecase             " Case is ignored when completing file names and directories.
set wildignore+=*.swp,*/tmp/   " A file that matches with one of these patterns is ignored when expanding wildcards, completing file or directory names.

" =========================== "
" === Indentation Options === "
" =========================== "

set autoindent " Remember indent level after going to the next line.

" Use 2-space soft tabs by defaults
" (it's overriden for some some languages with different conventions).
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Indent/Unindent visually selected lines without losing the selection.
vnoremap > >gv
vnoremap < <gv
" Indent single lines with a single keystroke. The ability to specify a motion
" is lost, but this caters for the more common use case, indent until the
" desired level is obtained.
nnoremap > >>
nnoremap < <<

" ================ "
" === Markdown === "
" ================ "

" Highlight syntax by default when entering an md file
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" In modern Vim the markdown plugin is included by default in the Vim
" distribution itself.
let g:markdown_fenced_languages = [
      \ 'go',
      \ 'golang=go',
      \ 'html',
      \ 'javascript',
      \ 'json',
      \ 'python',
      \ 'ruby',
      \ 'bash=sh',
      \ 'sh',
\]

let g:markdown_minlines = 100 " allow for more lines to be syntax highlighted
let g:markdown_syntax_conceal = 0 " don't mess with how the actual content is displayed

" ===================== "
" === Mouse Support === "
" ===================== "

" Reference <https://stackoverflow.com/a/19253251/1613695>
if !has('nvim')
  set mouse=a " enable mouse mode
  if has("mouse_sgr")
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  end
end

" ============================= "
" === Quickfix List Options === "
" ============================= "

" Useful for any type of search and command that populates the quickfix list.
nmap [q :cprevious<CR>
nmap ]q :cnext<CR>

" Open quickfix results in vertical and horizontal splits, with the same
" shortcuts provided by default by CtrlP (<C-v> and <C-x>).

" Picking just the functionality we need from https://github.com/yssl/QFEnter

" This will only be called in the quickfix window, owing to the filetype
" restriction on the autocmd (see below).
function! <SID>OpenQuickfix(new_split_cmd)
  " 1. the current line is the result idx as we are in the quickfix
  let l:qf_idx = line('.')
  " 2. jump to the previous window
  wincmd p
  " 3. switch to a new split (the new_split_cmd will be 'vnew' or 'split')
  execute a:new_split_cmd
  " 4. open the 'current' item of the quickfix list in the newly created buffer
  "    (the current means, the one focused before switching to the new buffer)
  execute l:qf_idx . 'cc'
endfunction

autocmd FileType qf nnoremap <buffer> <C-v> :call <SID>OpenQuickfix("vnew")<CR>
autocmd FileType qf nnoremap <buffer> <C-x> :call <SID>OpenQuickfix("split")<CR>

" ====================== "
" === Search Helpers === "
" ====================== "

" Based on
" * https://github.com/bryankennedy/vimrc/blob/master/vimrc
" * http://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
" * http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim

" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
function! VimEscape(string)
  let string=a:string
  " Escape regex characters
  let string = escape(string, '^$.*\/~[]')
  " Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

" Return the visually selected text without altering the unnamed register.
function! GetVisual() range
  " Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&

  " Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')

  " Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save

  return selection
endfunction

function! GetVimEscapedVisual() range
  return VimEscape(GetVisual())
endfunction

function! ShellEscape(str)
  let str=a:str
  return shellescape(fnameescape(str))
endfunction

function! GetShellEscapedVisual() range
  return ShellEscape(GetVisual())
endfunction

" ====================== "
" === Search Options === "
" ====================== "

set ignorecase  " Ignore case when searching...
set smartcase   " ...unless one upper case letter is present in the word
set gdefault    " Replace all the occurences in the line by default
set incsearch   " Start searching without pressing enter
set hlsearch    " Highlight results

" Search and replace current word
nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

" Start the find and replace command across the entire file
vnoremap <Leader>r <Esc>:%s/<c-r>=GetVimEscapedVisual()<cr>//c<Left><Left>

" http://vim.wikia.com/wiki/Search_for_visually_selected_text
" http://vim.wikia.com/wiki/VimTip171
" http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html
" https://github.com/nelstrom/vim-visual-star-search
" http://vimcasts.org/episodes/search-for-the-selected-text/
"
" Search for selected text, forwards or backwards. It is case insensitive, and
" any whitespace is matched ('hello\nworld' matches 'hello world'

" Makes * and # work on visual mode too.
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" ====================== "
" === Spell checking === "
" ====================== "

" toggle spell checking with <F6>
nnoremap <F6> :setlocal spell!<CR>
vnoremap <F6> :setlocal spell!<CR>
inoremap <F6> <Esc>:setlocal spell!<CR>

" Automatically enable spell checking for some filetypes.
" <http://robots.thoughtbot.com/vim-spell-checking>
" autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" =============================== "
" === Text Formatting Options === "
" =============================== "

" Ensure some formatting options, some of which may already be enabled by
" default, depending on the version of Vim.
" Wrap text automatically both for text (t) and comments (c).
" Auto-add current comment leader on new lines both in insert mode (r) and
" normal mode (o).
" Remove the comment characters when joining lines (j).
" Allow formatting of comments with 'gq' (q).
set formatoptions+=jtcroq
" For auto-formatting of text (not just comments) to work, textwidth must be
" explicitly set (it's 0 by default).
set textwidth=79
" Also wrap existing long lines when adding text to it (-l).
" Respect new lines with a paragraph (-a).
set formatoptions-=la

" Disabling auto formatting for the following file types because the wrapping
" also seems to be applied to code.
autocmd FileType swift,erb,sh set formatoptions-=t

" Use only one space after punctuation:
" http://en.wikipedia.org/wiki/Sentence_spacing#Typography
set nojoinspaces

" I - When moving the cursor up or down just after inserting indent for i
" 'autoindent', do not delete the indent. (cpo-I)
set cpoptions+=I

" ============================= "
" === Text Wrapping Options === "
" ============================= "

set nowrap " Do not visually wrap lines by default.

if version > 704
  set breakindent " Align visually wrapped lines with the original indentation.
endif

set linebreak " Break between words when wrapping (don't break within words).
nmap <silent> <leader>w :set wrap!<CR> " toggle wrapping with leader-w

" ====================== "
" === Visual Options === "
" ====================== "

syntax on                 " syntax highlighting.
filetype plugin indent on " automatically detect file types.

set number " show line numbers

set cursorline  " highlight the current line.
set showmatch   " highlight matching parentheses.
set matchtime=0 " ...but stay out of the way (do not jump around).

set noerrorbells visualbell t_vb= " disable all bells
set showcmd                       " show command that is being entered in the lower right
set backspace=indent,eol,start    " allow extended backspace behaviour
set virtualedit=block             " allow placing the cursor after the last char

if exists('+colorcolumn')
  set colorcolumn=81,101 " display vertical rulers for line length
endif

" ================== "
" === Whitespace === "
" ================== "

set listchars=tab:»·,trail:·,extends:>,precedes:<
" toggle hidden characters highlighting:
nmap <silent> <Leader>h :set nolist!<CR>

function! <SID>StripTrailingWhitespaces()
  " store the original position
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e " end of lines
  %s/\n\{3,}/\r\r/e " multiple blank lines
  silent! %s/\($\n\s*\)\+\%$// " end of file
  call cursor(l, c) " back to the original position
endfun

autocmd FileType Dockerfile,make,c,coffee,cpp,css,eruby,eelixir,elixir,html,java,javascript,json,markdown,php,puppet,python,ruby,scss,sh,sql,text,tmux,typescript,vim,yaml autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" ====================== "
" === Plugin Options === "
" ====================== "

" =========== "
" === Ack === "
" =========== "

let s:agignore =
  \ ' --ignore-dir=.bin'.
  \ ' --ignore-dir=.bundle'.
  \ ' --ignore-dir=bundle'.
  \ ' --ignore-dir=.git'.
  \ ' --ignore-dir=.hg'.
  \ ' --ignore-dir=.svn'.
  \ ' --ignore-dir=log'.
  \ ' --ignore-dir=node_modules'.
  \ ' --ignore-dir=vendor'.
  \ ' --ignore=*.class'.
  \ ' --ignore=*.dll'.
  \ ' --ignore=*.exe'.
  \ ' --ignore=*.pyc'.
  \ ' --ignore=*.so'.
  \ ' --ignore=tags'

if executable('ag')
  let g:ackprg = 'ag --hidden --follow --smart-case --skip-vcs-ignores' . s:agignore
endif

" do no jump to the first result
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

let g:ackhighlight = 1 " highlight the searched term

" Search for visual selection
vnoremap <Leader>a y:Ack <C-r>=GetShellEscapedVisual()<CR>

" ============= "
" === CtrlP === "
" ============= "

" Open CtrlP window in mixed mode by default. This searches in files, buffers
" and MRU files at the same time.
let g:ctrlp_cmd = 'CtrlPMixed'

let g:ctrlp_show_hidden = 1
" open new file with <c-y> in the current window instead of v-split, to be
" consistent with the behaviour of the `:edit' command
let g:ctrlp_open_new_file = 'r'
" the max height for the results is still 10, but can be scrolled up if there
" are more
let g:ctrlp_match_window = 'results:100'
" when opening multiple files (selected with <c-z> and <c-o>)...
"   - open the first in the current window, and the rest as hidden
"     buffers (option 'r')
"   - set the maximum number of splits to use to '1' (which means only the
"     current one, no new splits will be created)
" unlike 'ij', this also works when the only buffer is the no-name buffer
let g:ctrlp_open_multiple_files = 'r1'

" only effective if `ag' not available
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](\.git|\.hg|\.svn|\.bundle|bin|node_modules|log|vendor)$',
  \ 'file': '\v\.(exe|so|dll|class|pyc)$',
\ }

" Use ag if available, because faster.
" Normally ag excludes directories like `git', but the `--hidden' option
" overrides that. We need therefore to explicitly specify the paths to be
" ignored.
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden --skip-vcs-ignores -g "" ' . s:agignore
endif

" Ignore space chars in file finder by designating spaces as an abbreviation
" for empty string that's expanded in fuzzy search, filename, full path &
" regexp modes (set in the mode attr).
" https://github.com/kien/ctrlp.vim/blob/master/doc/ctrlp.txt
" Fixes fuzzy searching files with space seperated terms
let g:ctrlp_abbrev = {
  \ 'gmode': 'i',
  \ 'abbrevs': [
    \ {
      \ 'pattern': ' ',
      \ 'expanded': '',
      \ 'mode': 'pfrz',
    \ },
  \ ]
\ }

" use ctrlp in a single shortcut to navigate buffers
noremap <Leader>b :CtrlPBuffer<CR>
let g:ctrlp_switch_buffer = 0

" include the current file
let g:ctrlp_match_current_file = 1

" ================ "
" === NERDTree === "
" ================ "

map <Leader>n :NERDTreeToggle<CR> " Shortcut to open/close
map <Leader>f :NERDTreeFind<CR>   " Highlight the current buffer (think of 'find')

let NERDTreeMinimalUI=1  " start NERDTree in minimal UI mode (No help lines)
let NERDTreeShowHidden=1 " show hidden files at startup

let NERDTreeAutoDeleteBuffer=1      " automatically replace/close the corresponding buffer when a file is moved/deleted
let NERDTreeCascadeSingleChildDir=0 " do not collapse on the same line directories that have only one child directory

" http://superuser.com/questions/184844/hide-certain-files-in-nerdtree
" https://github.com/scrooloose/nerdtree#faq
" How can I close vim if the only window left open is a NERDTree?
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeIgnore=[
  \ '\.pyc$',
  \ '\.class$',
  \ '^.undodir$',
  \ '^Session.vim$'
\ ]

" ============== "
" === Tagbar === "
" ============== "

nmap <F12> :TagbarToggle<CR>

" =================
" === UltiSnips ===
" =================

" Use tab for snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" =================== "
" === vim-airline === "
" =================== "

let g:airline_theme='base16_default' " milder colorschemes (pending the creation of a 16-color colorscheme)

let g:airline#extensions#tabline#enabled=1        " enable the list of buffers
let g:airline#extensions#tabline#fnamemod=':t'    " show just the filename
let g:airline#extensions#tabline#buffer_nr_show=1 " show buffer number in status bar

let g:airline#extensions#branch#enabled=0 " disable showing the branch

" Toggle the buffer/tab line with 'leader-t' (think of 'Toggle Tabs')
nnoremap <expr><silent> <Leader>t &showtabline ? ":set showtabline=0\<cr>" : ":set showtabline=2\<cr>"

" Keep the tabline hidden by default
autocmd VimEnter * :set showtabline=0

" ====================== "
" === vim-commentary === "
" ====================== "

autocmd FileType proto setlocal commentstring=//\ %s
autocmd FileType sql setlocal commentstring=--\ %s

" ============== "
" === vim-go === "
" ============== "

let g:go_fmt_command = "goimports"

let g:go_highlight_extra_types=1       "
let g:go_highlight_operators=1         "
let g:go_highlight_functions=1         "
let g:go_highlight_methods=1           "
let g:go_highlight_fields=1            "
let g:go_highlight_types=1             "
let g:go_highlight_format_strings=1    "
let g:go_highlight_string_spellcheck=1 " specify it even if it's currently the default

let g:go_auto_type_info=1 " when hovering with the cursor, show information about the identifier...
set updatetime=100        " ...after only 100 ms instead of the default 800

autocmd FileType go nnoremap <Leader>z :GoBuild<CR>

" ===================== "
" === vim-workspace === "
" ===================== "

let g:workspace_create_new_tabs=0

" Close NERDTree before making session.
autocmd VimLeave * NERDTreeClose

" ==================== "
" === tmux support === "
" ==================== "

" Also see the corresponding tmux configuration in these dotfiles.

function! TmuxWinCmd(direction)
  let wnr=winnr()
  " try to move...
  silent! execute 'wincmd ' . a:direction
  " ...and if does nothing it means that it was the last vim pane,
  " so we forward the command back to tmux
  if wnr == winnr()
    call system('tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR'))
  end
endfunction

nmap <M-Up>    :call TmuxWinCmd('k')<CR>
nmap <M-Down>  :call TmuxWinCmd('j')<CR>
nmap <M-Left>  :call TmuxWinCmd('h')<CR>
nmap <M-Right> :call TmuxWinCmd('l')<CR>

nmap <M-k> :call TmuxWinCmd('k')<CR>
nmap <M-j> :call TmuxWinCmd('j')<CR>
nmap <M-h> :call TmuxWinCmd('h')<CR>
nmap <M-l> :call TmuxWinCmd('l')<CR>

" this enables to use native and custom key combos inside tmux,
" as well as in standalone vim;
" relies on the term being correctly set inside tmux
if &term =~ '^screen'
  exec "set <xUp>=\e[1;*A"
  exec "set <xDown>=\e[1;*B"
  exec "set <xRight>=\e[1;*C"
  exec "set <xLeft>=\e[1;*D"
endif

" ==================== "
" === .vimrc.after === "
" ==================== "

if filereadable(glob("~/.vimrc.after"))
  source ~/.vimrc.after
endif
