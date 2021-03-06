set nospell
filetype plugin on

"---------Latex_______--------------------------------------------------

command Ltx w|!pdflatex % && gnome-open %:r.pdf & disown

inoremap <F4> <C-O>:Ltx
nnoremap <F4> :Ltx
onoremap <F4> <C-C>:Ltx
vnoremap <F4> :Ltx

noremap <F3> :w !detex \| wc <CR>

"---------standard options--------------------------------------------------

set hlsearch
set smartcase

set expandtab
set shiftwidth=2
set softtabstop=2
set textwidth=80
set nojs

vnoremap > >gv
vnoremap < <gv

set mouse=a

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" Show last status all the time
set ls=2
set statusline=%<%F\ %h%m%r%y%=%-14.(%l/%L,%c%V%)\ %P
:let g:buftabs_in_statusline=1

nmap ,d :bp<bar>bd#<cr>
nmap ,e :e <C-R>=expand("%:p:h") . "/" <CR>

set tabpagemax=1
set foldmethod=syntax
set foldlevelstart=99

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/ " Match trailing whitespac

" Set swap files to live on local disk
set directory=~/.vim/cache//

" sudo to write
cnoremap w!! w !sudo tee % >/dev/null

"remove trailing whitespace from all files
autocmd BufWritePre * : :%s/\s\+$//e

"abbreviations
iab #i #include
iab #d #define

set shellcmdflag=-c
let $BASH_ENV = "~/.bash_aliases"

" Completion
set wildmode=list:longest

set wildmenu
set wildignore=*.swp,*.bak,*.d
"set wildignore+=*/.svn/*,/*.hg/*,/*.git/* " Version control
set wildignore+=*/.virtualenvs/*
set wildignore+=*.aux,*.out,*.toc " LaTeX stuff
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg "Pics
set wildignore+=*.o,*.obj,*.pyc,*.class "compiled files, bytecode
set wildignore+=*.DS_Store
set wildignore+=*.pdf,*.xls,*.xlsx,*.doc
set wildignore+=*.jar


inoremap <F5> <C-O>:make<Space>-j
nnoremap <F5> :make<Space>-j
onoremap <F5> <C-C>:make<Space>-j
vnoremap <F5> :make<Space>-j

"avoid escape!
:imap jk <Esc>
:imap Jk <Esc>
:imap jK <Esc>
:imap JK <Esc>
"avoid escape!
:imap kj <Esc>
:imap kJ <Esc>
:imap Kj <Esc>
:imap KJ <Esc>


"tab next/previous
map H :bp!<CR>
map L :bn!<CR>
noremap <C-PageUp> :bp!<CR>
noremap <C-PageDown> :bn!<CR>


"quick edit/source vimrc
nmap ,v :e ~/.vimrc<return>
nmap ,s :source ~/.vimrc<return>

nmap ,m :make -j<return>

"time out on key codes but not mappings
set notimeout
set ttimeout
set ttimeoutlen=10

"delete gets lot"
set bs=2

noremap K <nop>
    " disable the shift K command because I hit it and it does annoying things
    "
set t_Co=256
set bg=dark

if filereadable("/usr/share/vim/google/google.vim ")
  source /usr/share/vim/google/google.vim
  Glug youcompleteme-google
  let g:ycm_autoclose_preview_window_after_completion = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1
endif

syntax on
noremap <silent> <C-n> :let @/="azsfaesrgesdsdrswer"<CR>

inoremap {<CR> {<CR>}<Esc>O
inoremap <silent> <C-d> <esc>ddko
inoremap <silent> <C-f> <esc>kJi

"---------resizing splits----------------------------------------------------
"noremap = <esc><C-w>>
    " = increase size of vertically split window
noremap - <esc><C-w><
    " - decrease size of vertically split window
noremap + <esc><C-w>+
    " + increase size of horizontally split window
noremap _ <esc><C-w>-
    " _ decrease size of horizontally split window

"----------moving between splits------------------------------------
noremap gh <esc><C-w><Left>
    " gh moves left one vertically split window
noremap gl <esc><C-w><Right>
    " gl moves right one vertically split window
noremap gj <esc><C-w><Down>
    " gj moves down one horizontally split window
noremap gk <esc><C-w><Up>
    " gk moves up one horizontally split window

"---------home, end, pgup, pgdn-----------------------------------------------
noremap <silent> <C-l> $
    " <C-l> goes to end of line
noremap <silent> <C-h> ^
    " <C-h> goes to beginning of line
inoremap <silent> <C-l> <esc>A
    " <C-l> goes to end of line in insert mode
inoremap <silent> <C-h> <esc>^i
    " <C-h> goes to beginning of line in insert mode

"---------compiler error window---------------------------------------------
noremap <silent> cn <esc>:cn<CR>
    " cn goes to the next compiler error (must compile with :make in vim)
noremap <silent> cp <esc>:cp<CR>
    " cp goes to the previous compiler error (must compile with :make in vim)

"---------don't fill buffer with single char delete-------------------------
noremap <silent> x "_x

"-------comments ------------------------------------------------------------
let b:comment_leader = '// '
au FileType c,cpp,java,javascript let b:comment_leader = '// '
au FileType haskell,vhdl,ada let b:comment_leader = '--'
au FileType vim let b:comment_leader = '"'
au FileType sh,make,r,python,cmake,conf let b:comment_leader = '#'
au FileType matlab,tex let b:comment_leader = '%'
    "set up comment characters for given filetypes

noremap ,c mC :call Comment()<cr> 'C
noremap ,u mC :call Uncomment()<cr> 'C

function! Comment() range
    for lineno in range(a:firstline, a:lastline)
        let line = getline(lineno)
        if strlen(line) > 0
            let nonws = matchend(line, '^\s*')
            let sbegin = strpart(line, 0, nonws)
            let send   = strpart(line, nonws)
            let cleanLine = sbegin . b:comment_leader . send
            call setline(lineno, cleanLine)
        endif
    endfor
endfunction

function! Uncomment() range
    for lineno in range(a:firstline, a:lastline)
        let line = getline(lineno)
        let nonws = matchend(line, '^\s*')
        let com = match(line, b:comment_leader, nonws)
        if com == nonws
            let cleanLine = substitute(line, b:comment_leader, "", 'e')
            call setline(lineno, cleanLine)
        endif
    endfor
endfunction


"noremap <silent> ,c :<C-B>sil <C-E>s/^\(\s*\)/\1<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
"noremap <silent> ,u :<C-B>sil <C-E>s/^\(\s*\)\V<C-R>=escape(b:comment_leader,'\/')<CR>/\1/e<CR>:noh<CR>

"-------tags----------------------------------------------------------------
"set tags=./tags;/
    ""sets default tag file name
"noremap <silent> th <esc>:pclose<CR>
    "" th closes preview window
"noremap <silent> tJ <esc>:exec("tag ".expand("<cword>"))<CR>
    "" tJ to open the tag
"noremap <silent> tj <esc>:exec("ptag ".expand("<cword>"))<CR>
    "" tj preview the tag
"noremap <silent> t<C-j> <esc>:vsp <CR>:exec("tag ".expand("<cword>"))<CR>
    "" t<C-j> opens the destination of following the tag in a vsplit window
"noremap <silent> tK <esc>:exec("tselect ".expand("<cword>"))<CR>
    "" tK executes tag select
"noremap <silent> tk <esc>:exec("ptselect ".expand("<cword>"))<CR>
    "" tk previews the tag select
"noremap <silent> t<C-k> <esc>:vsp <CR>:exec("tselect ".expand("<cword>"))<CR>
    "" t<C-k> opens the tselect of the tag in a vsplit window

"------DICT----------------
"set dictionary-=/usr/share/dict/words
"set dictionary+=/usr/share/dict/words

"set complete-=i
"set complete-=k
"set complete+=k

set completeopt=longest,menuone

"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"
"inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  "\ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
"
"inoremap <expr> <C-e> pumvisible() ? '<C-n>' :
  "\ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

"set omnifunc=syntaxcomplete#Complete

" Set a nicer foldtext function
set foldtext=MyFoldText()
function! MyFoldText()
  let line = getline(v:foldstart)
  if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
    let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
    let linenum = v:foldstart + 1
    while linenum < v:foldend
      let line = getline( linenum )
      let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
      if comment_content != ''
        break
      endif
      let linenum = linenum + 1
    endwhile
    let sub = initial . ' ' . comment_content
  else
    let sub = line
    let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
    if startbrace == '{'
      let line = getline(v:foldend)
      let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
      if endbrace == '}'
        let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
      endif
    endif
  endif
  let n = v:foldend - v:foldstart + 1
  let info = " " . n . " lines"
  let sub = sub . "                                                                                                                  "
  let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
  let fold_w = getwinvar( 0, '&foldcolumn' )
  let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
  return sub . info
endfunction

set autochdir
set autoread

noremap ty "+y
noremap tY "+Y
noremap td "+d
noremap tD "+D
noremap tp "+p
noremap tP "+P

set colorcolumn=+1
colorscheme wombat256mod
highlight ColorColumn NONE
highlight link ColorColumn ErrorMsg

" Disable Arrow keys in Escape mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Disable Arrow keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

