set encoding=utf-8
scriptencoding utf-8

" --------------- "
" --- Plugins --- "
" --------------- "

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" --- General power-ups ---

Plug 'SirVer/ultisnips'
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'ruanyl/vim-gh-line'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'

" --- Search (files and code) ---

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-grepper'

" --- Navigate (files and code) ---

Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'majutsushi/tagbar'
Plug 'preservim/nerdtree'

" --- Language support (including special config syntaxes) ---

Plug 'Quramy/tsuquyomi'
Plug 'cespare/vim-toml'
Plug 'dense-analysis/ale'
Plug 'ekalinin/Dockerfile.vim'
Plug 'elzr/vim-json'
Plug 'evanleck/vim-svelte'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'hashivim/vim-hashicorp-tools'
Plug 'hashivim/vim-terraform'
Plug 'keith/swift.vim'
Plug 'leafgarland/typescript-vim'
Plug 'lervag/vimtex'
Plug 'mustache/vim-mustache-handlebars'
Plug 'pangloss/vim-javascript'
Plug 'rodjek/vim-puppet'
Plug 'rust-lang/rust.vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-git'
Plug 'vim-ruby/vim-ruby'

" --- Markdown ---

" Tim Pope's Markdown plugin is included in Vim, but we want the latest
" version.
Plug 'tpope/vim-markdown'

" Tim Pope's Markdown plugin is the only one we know of that respects Vim
" formatting abilities (namely: correct recognition of paragraphs and lists),
" but its syntax highlight is often incorrect. vim-pandoc-syntax supports
" a superset of markdown.
Plug 'vim-pandoc/vim-pandoc-syntax'

" --- Color schemes ---

Plug 'altercation/vim-colors-solarized'
" nord-vim only works if the terminal itself is using the 16-color Nord theme
Plug 'arcticicestudio/nord-vim'
Plug 'jsit/disco.vim'
Plug 'lifepillar/vim-gruvbox8'
Plug 'rakr/vim-one'
Plug 'romainl/apprentice'
Plug 'sonph/onehalf', { 'rtp': 'vim' }

call plug#end()

"-----------------------"
"--- Auto-formatting ---"
"-----------------------"

" --- Autoformat JSON with jq ---

if executable('jq')
  " -M monochrome
  " -r raw output
  autocmd FileType json command! -nargs=0 Format execute ':%! jq -Mr .'
endif

" --- Autoformat XML with xmllint ---

if executable('xmllint')
  autocmd FileType xml command! -nargs=0 Format execute ':%! xmllint --format --nowarning -'
endif

" ---------------------- "
" --- Buffer Options --- "
" ---------------------- "

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

" --- Close all hidden non-special buffers ---"

" http://stackoverflow.com/questions/1534835/how-do-i-close-all-buffers-that-arent-shown-in-a-window-in-vim
" modified to ensure that the buffers to close are normal (listed) buffers
"
" Other similar functions:
" http://stackoverflow.com/questions/8450919/how-can-i-delete-all-hidden-buffers>
" https://gist.github.com/skanev/1068214>
" http://vim.1045645.n5.nabble.com/close-all-unvisible-buffers-td4262697.html>
function! s:CloseHiddenBuffers()
  " figure out which buffers are visible in any tab
  let visible = {}
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let visible[b] = 1
    endfor
  endfor
  " close any buffer that's loaded and not visible and not special
  for b in range(1, bufnr('$'))
    " add buflisted() to avoid closing special buffers
    if bufloaded(b) && !has_key(visible, b) && buflisted(b)
      exe 'bd ' . b
    endif
  endfor
endfun

nnoremap <Leader>ch :call <SID>CloseHiddenBuffers()<CR>

" ------------------- "
" --- Colorscheme --- "
" ------------------- "

" Try to use 'peachpuff' if available, because it's a 16-color scheme that
" adapts acceptably well to dark and light background terminals, at the same
" time, which is useful for pairing in shared sessions.
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

" -------------------------- "
" --- Completion options --- "
" -------------------------- "

set wildmode=list:longest,full " Open a list of all the matches (list) *and* cycle through them (full)
set wildignorecase             " Case is ignored when completing file names and directories.
set wildignore+=*.swp,*/tmp/   " A file that matches with one of these patterns is ignored when expanding wildcards, completing file or directory names.

set completeopt-=preview " do not open Preview split with docs for completion entries

" ---------------------- "
" --- Copy and Paste --- "
" ---------------------- "

set pastetoggle=<F3>

" --- Paste over visual selection preserving content of the paste buffer ---

" p   -> paste normally
" gv  -> reselect the pasted text
" y   -> copy it again
" `>  -> jump to the last character of the visual selection (built-in mark)
vnoremap <Leader>p pgvy`>

" --- Make shift-Y consistent with shift-C and shift-D ---

" shift-C changes till the end of line, and shift-D deletes till the of the line.
" shift-Y breaks the pattern, and it's an alias for `yy'.
" This was once in vim-sensible but then removed.
nnoremap Y y$

" --- copy current file and line to the system clipboard ---

nnoremap <leader>y :let @+=expand("%:p") . ':' . line(".")<CR>

" --- Enter Insert mode directly in Paste mode ---

" 'borrowed' from
" <https://github.com/zonk1024/vim_stuffs/blob/281b4dfe92d4883550659989c71ec72350f3dd10/vimrc#L129>

" Turns on paste mode, puts you in insert mode then autocmds the cleanup
function! InsertPaste() range
  set paste
  startinsert
  augroup PasteHelper
    autocmd InsertLeave * call LeavePaste()
  augroup END
endfunction

" Same as above but on a new line
function! InsertPasteNewLine() range
  set paste
  call append(line("."), "")
  exec line(".")+1
	startinsert
  augroup PasteHelper
    autocmd InsertLeave * call LeavePaste()
  augroup END
endfunction

" Cleanup by turning off paste mode and unbinding itself from InsertLeave
function! LeavePaste() range
  set nopaste
  augroup PasteHelper
    autocmd!
  augroup END
endfunction

nnoremap <Leader>i :call InsertPaste()<CR>
nnoremap <Leader>o :call InsertPasteNewLine()<CR>

" ---------------------- "
" --- Cursor options --- "
" ---------------------- "

" --- remember position when reopening a file ---

" Exclude git commit messages.
let cursorRestoreExclusions = ['gitcommit']

autocmd BufReadPost *
  \ if index(cursorRestoreExclusions, &ft) < 0
	\ && line("'\"") > 1
  \ && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" ------------------------- "
" --- Diff highlighting --- "
" ------------------------- "

" use simple ansi-colours for readability in any terminal with an ANSI palette
highlight DiffAdd     cterm=none,bold   ctermfg=2   ctermbg=15
highlight DiffDelete  cterm=none        ctermfg=13  ctermbg=15
highlight DiffChange  cterm=none        ctermfg=8   ctermbg=15
highlight DiffText    cterm=none,bold   ctermfg=4   ctermbg=15

" ------------------------------- "
" --- Disable unused features --- "
" ------------------------------- "

" reverting the keys in :q (therefore bringing up the command history) is quite
" common and almost never what one wants, so it's disabled;
" however, since the command history is indeed useful sometimes, it's still
" possible to summon it with the Vim-native :<C-f>
map q: <Nop>
" remap Ex mode to 'formatting'
map Q gq
" disable compatibility with old vi
set nocompatible

" --------------- "
" --- General --- "
" --------------- "

let s:swap_dir = $HOME . "/.vim/swp//"
let s:bkp_dir = $HOME . "/.vim/backup//"
let s:undo_dir = $HOME . "/.vim/undo//"

if !isdirectory(s:swap_dir) | call mkdir(s:swap_dir, "p", 0755) | endif
if !isdirectory(s:bkp_dir) | call mkdir(s:bkp_dir, "p", 0755) | endif
if !isdirectory(s:undo_dir) | call mkdir(s:undo_dir, "p", 0755) | endif

let &directory=s:swap_dir
let &undodir=s:undo_dir
let &backupdir=s:bkp_dir

set swapfile
set undofile
set backup

set lazyredraw

set timeoutlen=350 " reduce the command timeout (default 1000)

" --- jumping between pairs ---

set matchpairs+=<:>

set modeline " support vim options in individual files with magic comments.

" --- leader key alternatives --- "

" Preserves the native leader key.

nmap <space> \
vmap <space> \

" --- save without sudo ---

" http://www.commandlinefu.com/commands/view/1204/save-a-file-you-edited-in-vim-without-the-needed-permissions
if !exists(":Sudow")
  command Sudow :execute ':silent w !sudo tee % > /dev/null' | :edit!
endif

" --------------- "
" --- History --- "
" --------------- "

set history=1000

" there is another setting that might override the history size, so we ensure to
" set that too; see "h 'viminfo'" (with quotes)
"
" default options:
"
" !   save and restore global variables that start with an uppercase letter
" '   max number of files to remember for marks
" h   disable effect of 'hlsearch' when loading viminfo file
" <   max number of lines saved per register
" s   max size of each register item in Kbytes
"
" additional option:
"
" :   max number of entries in the command history
set viminfo=!,'100,<50,s10,h,:1000

" ------------------------------ "
" --- Move lines up and down --- "
" ------------------------------ "

" Move lines up and down with Ctrl-arrowup/down and Ctrl-j/k (in normal, visual and insert mode)
" NOTE: only meant for small selections and small movements, will break moving
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

" ------------------- "
" --- Real delete --- "
" ------------------- "
"
" Delete without yanking, send the deleted content to the 'black hole' register.
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

" also prevent 'x' from overriding what's in the clipboard
noremap x "_x
noremap X "_x

" -------------------- "
" --- Indentation --- "
" ------------------- "

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

" --------------------- "
" --- Mouse Support --- "
" --------------------- "

" Reference <https://stackoverflow.com/a/19253251/1613695>
set mouse=a " enable mouse mode
if has('mouse_sgr')
  set ttymouse=sgr
elseif !has('nvim')
  set ttymouse=xterm2
end

set ttyfast          " Send more characters for redraws (faster scrolling)
set mousehide        " Hide mouse pointer while typing
set mousemodel=popup

" -------------------- "
" --- Omnicomplete --- "
" -------------------- "

" Enable syntax-based for natively supported languages, and using ctags when
" available.
set omnifunc=syntaxcomplete#Complete

" instruct supertab to try and detect the most appropriate autocompletion
" method, thus minimising the need for pressing the `<C-x><C-o>` combination
let g:SuperTabDefaultCompletionType = "context"

" Allow the `enter' key to chose from the omnicompletion window, instead of <C-y>
" http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" ----------------------------- "
" --- Quickfix List Options --- "
" ----------------------------- "

" force quickfix to always use the full width of the terminal at the bottom
" (and only the quickfix, not the location list, which instead belongs to each
" specific buffer)
" https://stackoverflow.com/a/59823132/417375
autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif

" --- navigation ---

" Useful for any type of search and command that populates the lists.
nmap [q :cprevious<CR>
nmap ]q :cnext<CR>

nmap [l :lprevious<CR>
nmap ]l :lnext<CR>

" --- splits ---

" Open quickfix results in vertical and horizontal splits, with the same
" shortcuts provided by default by CtrlP (<C-v> and <C-x>).

" Picking just the functionality we need from https://github.com/yssl/QFEnter

" This will only be called in the quickfix window, owing to the filetype
" restriction on the autocmd (see below).
function! s:OpenQuickfix(new_split_cmd)
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

" ---------------------- "
" --- Search options --- "
" ---------------------- "

set ignorecase  " Ignore case when searching...
set smartcase   " ...unless one upper case letter is present in the word
set gdefault    " Replace all the occurences in the line by default
set incsearch   " Start searching without pressing enter
set hlsearch    " Highlight results

" normalise the search highlight colours
" This black text/bright yellow background works really well with Tango Light
" and most other terminal themes, but might require tweaking in the
" ~/.vimrc.local for some unconventional terminal themes (Solarized Light,
" Pastel...)
" See the README/TODO for more options.
highlight Search  term=reverse cterm=reverse      ctermfg=11  ctermbg=0
highlight Todo    term=reverse cterm=reverse,bold ctermfg=7   ctermbg=0
highlight Visual  term=reverse cterm=reverse      ctermfg=7   ctermbg=0

" Search and replace current word
nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

" highlight current word without jumping to the next occurrence
map <Leader>h :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>

" --- search for visual selection ---

" Search for selected text, forwards or backwards. It is case insensitive, and
" any whitespace is matched ('hello\nworld' matches 'hello world')
" makes * and # work on visual mode too.
"
" - http://vim.wikia.com/wiki/Search_for_visually_selected_text
" - http://vim.wikia.com/wiki/VimTip171
" - http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html
" - https://github.com/nelstrom/vim-visual-star-search
" - http://vimcasts.org/episodes/search-for-the-selected-text/
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" --- search and replace for visual selection ---

" Start the find and replace command across the entire file
vnoremap <Leader>r <Esc>:%s/<c-r>=GetVimEscapedVisual()<cr>//c<Left><Left>
vnoremap <C-r> <Esc>:%s/<c-r>=GetVimEscapedVisual()<cr>//c<Left><Left>

" ---------------------- "
" --- Spell checking --- "
" ---------------------- "

" toggle spell checking with <F6>
nnoremap <F6> :setlocal spell!<CR>
vnoremap <F6> :setlocal spell!<CR>
inoremap <F6> <Esc>:setlocal spell!<CR>

" Recompile the personal spell file if newer than the compiled version.
" Useful when synchronising the spell file with Dropbox or git.
" https://vi.stackexchange.com/a/5052
for dict in glob('~/.vim/spell/*.add', 1, 1)
  if filereadable(dict) && (!filereadable(dict . '.spl') || getftime(dict) > getftime(dict . '.spl'))
    silent exec 'mkspell! ' . fnameescape(dict)
  endif
endfor

" Automatically enable spell checking for some filetypes.
" <http://robots.thoughtbot.com/vim-spell-checking>
" autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" ----------------------- "
" --- Text formatting --- "
" ----------------------- "

" Ensure some formatting options, some of which may already be enabled by
" default, depending on the version of Vim.

" For auto-formatting of text (not just comments) to work, textwidth must be
" explicitly set (it's 0 by default).
set textwidth=79

" some of these options require that 'autoindent' is set
set formatoptions+=1 " don't break a line after a one letter word, but before
set formatoptions+=c " auto-wrap comments
set formatoptions+=j " remove the comment characters when joining lines
set formatoptions+=l " keep long lines when editing, if they were already long
set formatoptions+=n " recognise numbered lists (using 'formatlistpat')
set formatoptions+=q " allow formatting of comments with 'gq'
set formatoptions+=r " auto-add current comment leader on new lines both in insert mode
set formatoptions+=t " wrap text automatically using 'textwidth'

set formatoptions-=o " do not add comment leader to new lines created with 'o' or 'O'
set formatoptions-=a " do not reformat the entire paragraph on every change because it messes with commented code

" Disabling auto formatting for the following file types because the wrapping
" also seems to be applied to code.
autocmd FileType swift,erb,sh set formatoptions-=t

" Use only one space after punctuation:
" http://en.wikipedia.org/wiki/Sentence_spacing#Typography
set nojoinspaces

" I - When moving the cursor up or down just after inserting indent for i
" 'autoindent', do not delete the indent. (cpo-I)
set cpoptions+=I

" --------------------- "
" --- Text wrapping --- "
" --------------------- "

set nowrap " Do not visually wrap lines by default.

set breakindent " Align visually wrapped lines with the original indentation.
set linebreak   " Break between words when wrapping (don't break within words).

" toggle wrapping with leader-w
nmap <silent> <leader>w :set wrap!<CR>

" ---------------------- "
" --- Visual options --- "
" ---------------------- "

syntax on                 " syntax highlighting.
filetype plugin indent on " automatically detect file types.

set number " show line numbers

set cursorline  " highlight the current line.
set showmatch   " highlight matching parentheses.
set matchtime=0 " ...but stay out of the way (do not jump around).

set showcmd                       " show command that is being entered in the lower right
set noerrorbells visualbell t_vb= " disable all bells
set backspace=indent,eol,start    " allow extended backspace behaviour
set virtualedit=block             " allow placing the cursor after the last char
set scrolloff=3                   " number of lines visible when scrolling
set sidescroll=3
set sidescrolloff=3
set shortmess-=S                  " show match count in searches

if exists('+colorcolumn')
  set colorcolumn=81,101 " display vertical rulers for line length
  autocmd FileType qf set colorcolumn=
endif

" --- custom highlighting ---

" for some reason the vertsplit highlight needs to be placed after the set
" colorcolumn option
highlight VertSplit     cterm=none,reverse    ctermfg=8   ctermbg=8
highlight EndOfBuffer   cterm=none            ctermfg=15
highlight ColorColumn                                     ctermbg=15
highlight WildMenu      cterm=bold            ctermfg=0   ctermbg=11
highlight LineNr        cterm=none            ctermfg=7   ctermbg=none
highlight CursorLineNr  cterm=none,underline  ctermfg=8   ctermbg=none
highlight SignColumn    cterm=none                        ctermbg=none

" Add keywords to be highlighted as TODOs (https://vi.stackexchange.com/a/19043)
" The synTodo line:
" 1. list all syntax items (execute("syntax list"))
" 2. split it into a list of lines (split(..., '\n'))
" 3. filter it to only contain lines with syntax group name that ends with Todo (filter(..., { i,v -> match(v, '^\w*Todo\>') == 0}))
" 4. remove everything after syntax group name (map(..., {i,v -> substitute(v, ' .*$', '', '')}))
" result -> a list of syntax group names that end with Todo.
function! UpdateTodoKeywords(...)
  let newKeywords = join(a:000, " ")
  let synTodo = map(filter(split(execute("syntax list"), '\n') , { i,v -> match(v, '^\w*Todo\>') == 0}), {i,v -> substitute(v, ' .*$', '', '')})
  for synGrp in synTodo
    execute "syntax keyword " . synGrp . " contained " . newKeywords
  endfor
endfunction

augroup Todo_CustomKeywords
  autocmd!
  autocmd Syntax * call UpdateTodoKeywords("NOTE", "NOTES", "INFO", "REVIEW", "IDEA", "BUG", "TBD")
augroup END

" -------------------------------- "
" --- Visual selection helpers --- "
" -------------------------------- "

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

" ------------------ "
" --- Whitespace --- "
" ------------------ "

" noremap <silent> <Leader>w :call Wrap()<CR>

" --- Visualise whitespace ---
" toggle hidden characters highlighting:

set listchars=tab:▸·,trail:·,extends:>,precedes:<
nmap <silent> <Leader>ww :set nolist!<CR>

" --- highlight unwanted trailing whitespace --- "
" <https://vim.fandom.com/wiki/Highlight_unwanted_spaces#Highlighting_with_the_match_command>
"
" only in normal mode
highlight ExtraWhitespace cterm=reverse,bold ctermfg=1 ctermbg=none
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

function! s:StripTrailingWhitespaces()
  " store the original position
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e " end of lines
  %s/\n\{3,}/\r\r/e " multiple blank lines
  silent! %s/\($\n\s*\)\+\%$// " end of file
  call cursor(l, c) " back to the original position
endfun

autocmd FileType Dockerfile,make,c,coffee,cpp,css,eruby,eelixir,elixir,html,java,javascript,json,markdown,php,puppet,python,ruby,rust,scss,sh,sql,text,tmux,typescript,vim,yaml autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" also available for manual execution, for files where it's not enabled by default
command! WhitespaceTrailing call <SID>StripTrailingWhitespace()

" ---------------------- "
" --- Plugin Options --- "
" ---------------------- "

" ---------------------------------------------- "
" --- ALE (A.L.E., Asynchronous Lint Engine) --- "
" ---------------------------------------------- "

" --- ALE: Language settings ---

" set to 1 to disable all linters unless explicitly enabled, default 0
" let g:ale_linters_explicit = 1

let g:ale_lint_on_save = 1
let g:ale_linters = {
\  'go': ['golint', 'gopls', 'govet'],
\  'html': [],
\  'javascript': ['eslint'],
\  'python': ['flake8', 'pylint'],
\  'rust': ['analyzer'],
\}

let g:ale_fix_on_save = 1
let g:ale_fixers = {
\  '*': ['remove_trailing_lines', 'trim_whitespace'],
\  'python': ['yapf'],
\  'rust': ['rustfmt'],
\}

let g:ale_go_golangci_lint_options = '' " only use defaults

" undocumented: https://github.com/dense-analysis/ale/discussions/3977
" can be placed in a project-specific .vimrc, as exrc is enabled
" let g:ale_go_goimports_options = "-local=mymodule"

" struct literals without fields are useful, especially for special-purpose
" types with a single field (such as custom error types)
let g:ale_go_govet_options = '-composites=false'

let g:ale_go_langserver_executable = ''

let g:ale_go_gopls_options = '-remote=auto'
let g:ale_go_gopls_init_options = {
\  'ui.diagnostic.analyses': {
\    'composites': v:false,
\    'unusedresult': v:true,
\    'unusedwrite': v:true,
\    'nilness': v:true,
\    'unusedparams': v:true,
\  },
\}

" --- ALE: Error list customisation ---

" open the loclist automatically on errors; it will close anyway once all the
" issue have been addressed

let g:ale_open_list = 'on_save'

" --- ALE: Visual customisations ---

let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1

let g:ale_sign_error = ' ▶︎'
let g:ale_sign_warning = ' ▶︎'
let g:ale_sign_info = ' ▶︎'

" white on dark red
highlight ALEErrorSign cterm=reverse,bold ctermfg=1 ctermbg=none

" white on dark yellow
" highlight ALEWarningSign cterm=reverse,bold ctermfg=3 ctermbg=none

" black on bright yellow
highlight ALEWarningSign cterm=bold ctermfg=none ctermbg=11

" white on light blue
highlight ALEInfoSign cterm=reverse,bold ctermfg=12 ctermbg=none

" --- ALE: shortcuts ---

" mnemomic: 'd' is for 'diagnostic'
nmap <silent> ]d <Plug>(ale_next_wrap)
nmap <silent> [d <Plug>(ale_previous_wrap)

" ----------------------------------- "
" --- fzf and fzf.vim integration --- "
" ----------------------------------- "

" See also https://github.com/junegunn/fzf/blob/master/README-VIM.md

" NOTE: Most of the options set with envars in the shell will also apply when
" fzf is invoked in Vim. Check those options in case of unwanted behaviour.

" run in a less intrusive terminal buffer at the bottom
let g:fzf_layout = { 'down': '~30%' }
" command to generate tags file
let g:fzf_tags_command = 'ctags -R'
" disable the preview window
let g:fzf_preview_window = []
" do not jump to the existing window if the buffer is already visible
let g:fzf_buffers_jump = 0
" set fzf history specifically for use within Vim, separately from the global fzf history
let s:fzf_history_dir = $HOME . "/.vim/fzf-history//"
if !isdirectory(s:fzf_history_dir) | call mkdir(s:fzf_history_dir, "p", 0755) | endif
let g:fzf_history_dir = s:fzf_history_dir

" same keybindings used for CtrlP
nmap <C-p> :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>/ :BLines<CR>
" :History is similar to MRU buffers
nnoremap <Leader>m :History<CR>

" ---------------- "
" --- NERDTree --- "
" ---------------- "

" Shortcut to open/close
map <Leader>n :NERDTreeToggle<CR>
" Highlight the current buffer (think of 'find')
map <Leader>f :NERDTreeFind<CR>

let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
let NERDTreeNaturalSort=1
let NERDTreeIgnore = ['\.pyc$', '\.class$'] " http://superuser.com/questions/184844/hide-certain-files-in-nerdtree
let NERDTreeAutoDeleteBuffer=1 " automatically replace/close the corresponding buffer when a file is moved/deleted
let NERDTreeCascadeSingleChildDir=0 " do not collapse on the same line directories that have only one child directory
let NERDTreeStatusline="" " this seems to be ignored anyawy

" -------------- "
" --- TagBar --- "
" -------------- "

nnoremap gt :TagbarToggle<CR>

let g:tagbar_sort = 0 " list tags in order of appearance in the file

let g:tagbar_iconchars = ['▶', '◢']

" https://github.com/preservim/tagbar/wiki#markdown
let g:tagbar_type_markdown = {
  \ 'ctagstype'  : 'markdown',
  \ 'kinds'    : [
    \ 'c:chapter:0:1',
    \ 's:section:0:1',
    \ 'S:subsection:0:1',
    \ 't:subsubsection:0:1',
    \ 'T:l4subsection:0:1',
    \ 'u:l5subsection:0:1',
  \ ],
  \ 'sro'      : '""',
  \ 'kind2scope'  : {
    \ 'c' : 'chapter',
    \ 's' : 'section',
    \ 'S' : 'subsection',
    \ 't' : 'subsubsection',
    \ 'T' : 'l4subsection',
  \ },
  \ 'scope2kind'  : {
    \ 'chapter' : 'c',
    \ 'section' : 's',
    \ 'subsection' : 'S',
    \ 'subsubsection' : 't',
    \ 'l4subsection' : 'T',
  \ },
\ }

" ----------------- "
" --- ultisnips --- "
" ----------------- "

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" ---------------------- "
" --- vim-commentary --- "
" ---------------------- "

" Shortcuts
nmap <Leader>c gcc
vmap <Leader>c gc
" The underscore (_) represents the forward slash (/).
" See :help :map-special-keys.
" NOTE: this will not work with nnoremap and vnoremap
nmap <C-_> gcc
vmap <C-_> gc

autocmd FileType proto setlocal commentstring=//\ %s
autocmd FileType sql setlocal commentstring=--\ %s

" -------------- "
" --- vim-go --- "
" -------------- "

" --- vim-go: gofmt ---

" vim-go uses gopls by default for fmt
let g:go_fmt_autosave = 1
let g:go_fmt_fail_silently = 1

" --- vim-go: goimports ---

" vim-go uses gopls by default for imports
let g:go_imports_autosave = 1

" --- vim-go: general options ---

" let g:go_fillstruct_mode = 'gopls' " not working, reverting to default (2021-06-02)
let g:go_code_completion_icase = 1
let g:go_gopls_complete_unimported = v:true
let g:go_list_type = 'quickfix'
let g:go_gopls_use_placeholders = v:true " (v:null) treat autocompletion items as anonymous snippets
let g:go_addtags_skip_unexported = 1 " do not add JSON tags to unexported fields when using :GoAddTags

" show information about the identifier under the cursor (functions, vars..)...
let g:go_auto_type_info = 1
" ...after 1000 ms instead of the default 800
let g:go_updatetime=1000

 let g:go_addtags_skip_unexported = 1

 " --- vim-go: mappings ---

autocmd FileType go nnoremap <Leader>z :GoDiagnostics<CR>
autocmd FileType go nnoremap <Leader>t :GoTest<CR>
autocmd FileType go nnoremap <Leader>tf :GoTestFunc<CR>
autocmd FileType go nnoremap <Leader>e :GoDecls<CR>
autocmd FileType go nnoremap <Leader>ee :GoDeclsDir<CR>
autocmd FileType go nnoremap <Leader>s :GoSameIdsToggle<CR>

" --- vim-go: debugging ---

" \ 'out':        'botright 5new', " remove the output window
let g:go_debug_windows = {
    \ 'vars':       'leftabove 30vnew',
    \ 'stack':      'leftabove 20new',
    \ 'goroutines': 'botright 10new',
\ }

" default mappings when debugger is active:
"
"   go-debug-continue   <F5>
"   go-debug-print      <F6>
"   go-debug-breakpoint <F9>
"   go-debug-next       <F10>
"   go-debug-step       <F11>
"   go-debug-halt       <F8>
"
" additional ones will be merged into the defaults
let g:go_debug_mappings = {
   \ '(go-debug-stop)':     {'key': '<F7>'},
   \ '(go-debug-stepout)':  {'key': '<F12>'},
\ }

autocmd FileType go nnoremap <F2> :GoDebugTestFunc<CR>
autocmd FileType go nnoremap <F4> :GoDebugStart<CR>
autocmd FileType go nnoremap <F9> :GoDebugBreakpoint<CR>

" --- vim-go: syntax highlighting ---

highlight link goBuiltins Keyword

let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_functions = 1 " includes methods
let g:go_highlight_operators = 1
let g:go_highlight_string_spellcheck = 1 " even if it's currently the default
let g:go_highlight_types = 1

let g:go_highlight_generate_tags = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1

let g:go_highlight_debug = 0
let g:go_debug_breakpoint_sign_text = '▶︎'

" ------------------- "
" --- vim-grepper --- "
" ------------------- "

" --- general options --- "

" the grepper variable will be merged with the defaults once the plugin loads
let g:grepper = {}

" list the possible search tools (backends) in order of preference, only the
" available executables will remain available once the plugin loads
let g:grepper.tools = [
  \'rg',
  \'ag',
  \'pt',
  \'ack',
  \'git',
  \'grep',
\]

let g:grepper.highlight = 1 " highlight matches
" let g:grepper.stop = 1000 " stop searching after 1000 results, instead of the default 5000

" the following two settings will use the standard 10-line quickfix window
" no matter how many matches found; see ':h grepper-faq-4'
let g:grepper.open = 0
autocmd User Grepper copen

" focus the results automatically
let g:grepper.switch = 1

" --- prompt --- "
"
" the prompt is a nice to have, and provides different functionality than the
" command above, in particular shortcuts for changing search tool (with <Tab>)
" and target directory of the search (with <C-d>)
"
" however, it does not support path completion, and it causes a redraw when Esc
" is pressed

" this will open the Grepper prompt, where the search pattern can be entered
" (or by pressing Enter using the current word if no pattern is given)
nnoremap <Leader>g :Grepper<CR>

" only show a visual prompt, not the underlying search command;
let g:grepper.prompt_text = ' ❯❯ '

" --- Ack-like custom command --- "
"
" build a command that that supports both current word (when no args are given),
" and path completion (like :Ack), because the Grepper prompt does not support
" completion
"
" what suggested in the vim-grepper docs is not a solution: setting
"
"     let g:grepper.prompt = 0
"
" will allow path completion after the search pattern, but it will not search
" for the current word with no input
"
function! AckgFunc(query)
  if a:query == ''
    execute 'Grepper -noprompt -cword'
  else
    execute 'Grepper -noprompt -query ' . a:query
  endif
endfunction

command! -nargs=* -complete=file Ackg call AckgFunc(<q-args>)

nnoremap <Leader>a :Ackg<Space>

" -- search current word --- "

nnoremap <Leader>8 :Grepper -open -cword -noprompt -switch<CR>
nnoremap <Leader>* :Grepper -open -cword -noprompt -switch<CR>

" --- operator --- "
"
" enable the operator in normal and visual mode, it will take a range or
" motion; see :help grepper-operator
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" ---------------- "
" --- vim-json --- "
" ---------------- "

let g:vim_json_syntax_conceal = 0

" -------------------- "
" --- vim-markdown --- "
" -------------------- "

augroup pandoc_syntax
  autocmd! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
  autocmd! BufNewFile,BufFilePre,BufRead *.txt set filetype=markdown.pandoc
augroup END

let g:pandoc#syntax#conceal#use = 0
let g:pandoc#syntax#style#underline_special = 0
let g:pandoc#syntax#style#use_definition_lists = 0

let g:pandoc#syntax#codeblocks#embeds#langs = [
\  'go',
\  'ruby',
\  'bash=sh',
\  'zsh',
\  'plantuml',
\  'python',
\  'json',
\  'yaml',
\  'vim',
\]

" Highlight headers formatted with underlying '-' and '=' in bold cyan
highlight pandocSetexHeader cterm=bold ctermfg=6 ctermbg=none
highlight pandocAtxHeader ctermfg=6 ctermbg=none

" ----------------- "
" --- vim-rspec --- "
" ----------------- "

" --- Syntax highlighting outside Rails ---

autocmd BufRead {*_spec.rb,spec_helper.rb} syn keyword rubyRspec
      \ after
      \ before
      \ class_double
      \ contain_exactly
      \ context
      \ describe
      \ described_class
      \ double
      \ expect
      \ include_context
      \ include_examples
      \ instance_double
      \ it
      \ it_behaves_like
      \ it_should_behave_like
      \ its
      \ let
      \ object_double
      \ raise_error
      \ setup
      \ shared_context
      \ shared_examples
      \ shared_examples_for
      \ specify
      \ subject
      \ xit
      \ any_args
      \ anything
      \ array_including
      \ boolean
      \ duck_type
      \ hash_excluding
      \ hash_including
      \ instance_of
      \ kind_of
      \ no_args
      \ match_array

highlight def link rubyRspec Function

" ---------------- "
" --- vim-ruby --- "
" ---------------- "

" Highlight ruby operators (`/`, `&&`, `*`...)
let g:ruby_operators = 1

" ---------------- "
" --- vim-rust --- "
" ---------------- "

let g:rustfmt_autosave = 1       " automatically run rustfmt on save
let g:rust_recommended_style = 1 " disable recommended textwidth settings
let g:rust_fold = 1              " braced blocks are folded. All folds are open by default

augroup filetype_rust
  autocmd!
  autocmd FileType rust nnoremap <Leader>z :CBuild<CR>
  autocmd FileType rust setlocal tabstop=4 shiftwidth=4 softtabstop=4
augroup END

" ---------------- "
" --- vim-tmux --- "
" ---------------- "

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

nmap <silent> <M-Up>    :call TmuxWinCmd('k')<CR>
nmap <silent> <M-Down>  :call TmuxWinCmd('j')<CR>
nmap <silent> <M-Left>  :call TmuxWinCmd('h')<CR>
nmap <silent> <M-Right> :call TmuxWinCmd('l')<CR>

nmap <silent> <M-k>     :call TmuxWinCmd('k')<CR>
nmap <silent> <M-j>     :call TmuxWinCmd('j')<CR>
nmap <silent> <M-h>     :call TmuxWinCmd('h')<CR>
nmap <silent> <M-l>     :call TmuxWinCmd('l')<CR>

" this enables to use native and custom key combos inside tmux, as well as in
" standalone vim; relies on the term being correctly set inside tmux
"
"     set -g default-terminal 'tmux-256color'
"
if &term =~ '^tmux'
  exec "set <xUp>=\e[1;*A"
  exec "set <xDown>=\e[1;*B"
  exec "set <xRight>=\e[1;*C"
  exec "set <xLeft>=\e[1;*D"
endif

" --------------------- "
" --- vim-terraform --- "
" --------------------- "

let g:terraform_align=1       " Align settings automatically.
let g:terraform_fmt_on_save=1 " Run fmt on save.

" -------------- "
" --- vimtex --- "
" -------------- "

let g:tex_flavor="latex"

" ---------------------------------- "
" --- Reload vimrc automatically --- "
" ---------------------------------- "

" <https://github.com/bryankennedy/vimrc/blob/master/vimrc>
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

" -------------------- "
" --- .vimrc.after --- "
" -------------------- "

" You can put here any further customisations or overrides.
"
if filereadable(glob("~/.vimrc.after"))
  source ~/.vimrc.after
endif
