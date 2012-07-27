" General
" -------------------------------------------------------------
set enc=utf-8
set nocompatible
set shell=/bin/bash
set grepprg=/usr/bin/grep
set nobackup
set noswapfile
syntax on
filetype plugin on
filetype indent on

" Keymappings
" -------------------------------------------------------------
noremap - $
noremap <C-j> 3j
noremap <C-k> 3k
noremap <Space>. :<C-u>edit $MYVIMRC<Enter>
noremap <Space>s. :<C-u>source $MYVIMRC<Enter>
noremap <C-p> :bp<CR>
noremap <C-n> :bn<CR>
nnoremap Y y$
nnoremap R gR
nnoremap <C-d> :bd<CR>
" nnoremap <Space>h :hide bp!<CR>
" nnoremap <Space>l :hide bn!<CR>
vnoremap s y:%s/<C-R>"//g<Left><Left>
inoremap <C-b> <left>
inoremap <C-f> <right>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Del>
inoremap <C-k> <C-o>D
" inoremap <C-y> <C-o>p " This is too slow...
inoremap <C-j> <C-x><C-u>
inoremap <C-l> <C-o>:call ToggleLang()<Enter>
" File
" -------------------------------------------------------------
set hidden
set autoread
set isfname-==
set tags+=tags;
if has('persistent_undo')
  set undodir=./.vimundo,~/.vimundo
  set undofile
endif

" Editing
" -------------------------------------------------------------
set autoindent smartindent
set smarttab
set tabstop=4 softtabstop=4 shiftwidth=4
set expandtab
set cinoptions=t0,:0,g0,(0
set backspace=indent,eol,start
set formatoptions=tcqnmM
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<
set iskeyword+=!,?
set virtualedit=block

" Moving
" -------------------------------------------------------------
set showmatch matchtime=1
set matchpairs+=<:>
set whichwrap+=h,l,<,>,[,],b,s

" Display
" -------------------------------------------------------------
syntax on
colorscheme desert
highlight SpecialKey cterm=underline, ctermfg=darkgrey
set number
set nowrap
set ruler
set ruf=%45(%12f%=\ %m%{'['.(&fenc!=''?&fenc:&enc).']'}\ %l-%v\ %p%%\ [%02B]%)
set showcmd
set cmdheight=1
set laststatus=2
set shortmess+=I
set vb t_vb=

" Search
" -------------------------------------------------------------
set ignorecase
set smartcase
set incsearch
set hlsearch
set keywordprg=man\ -a

" Others
" -------------------------------------------------------------
runtime! ftplugin/man.vim

" Completion, History
" -------------------------------------------------------------
set wildmenu
set history=50
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
let g:qb_hotkey = "<C-c>"

set nu
set ic
set hls
set lbr


" Auto execute commands
augroup Autocmds
  au!
  au BufEnter * lcd %:p:h
  au BufNewFile *.h call IncludeGuard() | call C_Settings()
  au BufNewFile *.sh call append(0, "#!/bin/sh")             | normal! G
  au BufNewFile *.rb call append(0, "#!/usr/bin/env ruby")   | normal! G
  au BufNewFile *.py call append(0, "#!/usr/bin/env python") | normal! G
  au BufNewFile *.pl call append(0, "#!/usr/bin/env perl")   | normal! G
  au BufWritePost * silent! %s/\s\+$//e
  au BufReadPost * silent! set fileformat=unix
  au BufWritePost * if getline(1) =~ "^#!" | exe "silent !chmod +x %" | endif
  au BufNewFile,BufReadPost \cmakefile,*.mak setlocal noexpandtab
  au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

  au FileType c,cpp   call C_Settings()
  au FileType js      call JS_Settings()
  au FileType cpp     call Cpp_Settings()
  au FileType java    call Java_Settings()
  au FileType scala   call Scala_Settings()
  au FileType ruby    call Ruby_Settings()
  au FileType python  call Python_Settings()
  au FileType html    call HTML_Settings()
  au FileType vim     call Vim_Settings()
  au FileType yaml    call Yaml_Settings()
  au FileType cucumber call Yaml_Settings()
  au FileType text    setlocal textwidth=78
augroup END

" Language settings
" -------------------------------------------------------------

function! C_Settings()
  set isk-=!
  setlocal ts=4 sts=4 sw=4
  set fo-=ro
  if filereadable("./Makefile")
    setlocal makeprg=make
  else
    setlocal makeprg=gcc\ %
  endif
endfunction

function! JS_Settings()
  setlocal ts=4 sts=4 sw=4
endfunction

function! Cpp_Settings()
  call C_Settings()
  setlocal ts=2 sts=2 sw=2
endfunction

function! Java_Settings()
  setlocal ts=4 sts=4 sw=4
endfunction

function! Scala_Settings()
  setlocal ts=2 sts=2 sw=2
endfunction

function! Ruby_Settings()
  setlocal ts=2 sts=2 sw=2
  comp ruby
  nnoremap <buffer> <F5> :make %<CR>
  iab <buffer> ei each_with_index
endfunction

function! Python_Settings()
endfunction

function! HTML_Settings()
  setlocal sw=2 sts=2 ts=4
  inoremap <C-r>c <C-r>=system("randcolor")<CR>
  nnoremap <buffer> <F5> :!s %<CR>
endfunction

function! Vim_Settings()
  setlocal ts=2 sts=2 sw=2
  setlocal tw=0
  nnoremap <buffer> <F5> :so %<CR>
  setlocal formatoptions-=o
  " Execute selected region as a command
  nnoremap <space>e yy:@"<CR>
  vnoremap <space>e y:@"<CR>
endfunction

function! Yaml_Settings()
  setlocal ts=2 sts=2 sw=2
endfunction

" Other functions
" -------------------------------------------------------------
" Insert include guard
function! IncludeGuard()
let fl = getline(1)
  if fl =~ "^#if"
    return
  endif
  let basename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  normal! gg
  execute "normal! i#ifndef " . basename
  execute "normal! o#define " . basename .  "\<CR>\<CR>"
  execute "normal! Go#endif   /* " . basename . " */"
  3
endfunction

autocmd BufWritePost *.py call Flake8()
