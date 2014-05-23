"           __                              
"    __  __ /\_\     ___ ___    _ __   ___   
"   /\ \/\ \\/\ \  /' __` __`\ /\`'__\/'___\ 
"   \ \ \_/ |\ \ \ /\ \/\ \/\ \\ \ \//\ \__/ 
"    \ \___/  \ \_\\ \_\ \_\ \_\\ \_\\ \____\
"     \/__/    \/_/ \/_/\/_/\/_/ \/_/ \/____/
"   

set nocompatible "最初に必ず書く

set shellslash   "Windowsでディレクトリパスに/利用
set clipboard=unnamed "クリップボード連携for windows
"set t_Co=256

"外部のエディタで編集中のファイルが変更されたら自動的に読み直す
set autoread 

set enc=utf-8
set fenc=utf-8
set fencs=utf-8,iso-2022-jp,enc-jp,cp932


colorscheme delek  "カラースキーム
syntax on " シンタックスカラーリングオン

set visualbell "ビープ音の代わりに画面フラッシュ
"set transparency=221

"設定ファイル用コマンド追加
command! LoadVimrc  edit $MYVIMRC
command! LoadGvimrc  edit $MYGVIMRC
command! ReloadVimrc  source $MYVIMRC
command! ReloadGvimrc source $MYGVIMRC

"：と；の交換（面倒だから）
noremap ; :
noremap : ;

"表示関連
set showmatch   "()の対応をハイライト
set number      "行番号表示
set wrap        "画面幅で折り返す
"set list        "不可視文字の表示
"set listchars=tab:>\ "不可視文字の表示方法

set tabstop=4 "タブの空白数
set shiftwidth=4 "インデントの空白数

"検索関連
set ignorecase smartcase " 大文字が含まれている時のみ、大文字と小文字が区別される
set incsearch "インクリメンタルサーチ

"for java
let java_highlight_all=1
let java_highlight_debug=1
let java_space_errors=1

" ファイル関連
set nobackup   " バックアップ取らない
set autoread   " 他で書き換えられたら自動で読み直す
set noswapfile " スワップファイル作らない
set hidden     " 編集中でも他のファイルを開けるようにする

"括弧/クォーク自動保管
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

"Esc*２で検索ハイライト消去
nnoremap <Esc><Esc> :<C-u>set nohlsearch<Return>
nnoremap / :<C-u>set hlsearch<Return>/
nnoremap ? :<C-u>set hlsearch<Return>?
nnoremap * :<C-u>set hlsearch<Return>*
nnoremap # :<C-u>set hlsearch<Return>#

" ステイタス行に文字コードと改行コードを表示。
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set showcmd "入力途中のコマンドを表示 

"ノーマルモードで改行の挿入
noremap <CR> o<ESC>

"全角スペース　の可視化
highlight ZenkakuSpace guibg=red
match ZenkakuSpace /　/

set cmdheight=3

augroup BufferAu
    autocmd!
    " カレントディレクトリを自動的に移動
    autocmd BufNewFile,BufRead,BufEnter * if isdirectory(expand("%:p:h")) && bufname("%") !~ "NERD_tree" | cd %:p:h | endif
augroup END

if v:version >= 700
	set cursorline  "カレント行ハイライト

	"入力モード時、ステータスラインのカラーを変更
	augroup InsertHook
	autocmd!
	autocmd InsertEnter * highlight StatusLine guifg=#444444 guibg=#f6f3e8 gui=italic
	autocmd InsertLeave * highlight StatusLine guifg=#f6f3e8 guibg=#444444 gui=italic
	augroup END

	":grep:make実行後、自動的にQuickFixウィンドウを開く
	au QuickfixCmdPost make,grep,grepadd,vimgrep copen


	"for neovundle
	if has('vim_starting')
	  set rtp+=~/.vim/bundle/neobundle.vim/
	endif
	
	call neobundle#rc()

	" Let NeoBundle manage NeoBundle
	NeoBundleFetch 'Shougo/neobundle.vim'
	
	" Recommended to install
	" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
	NeoBundle 'Shougo/vimproc'
	
	NeoBundle 'scrooloose/nerdtree'
	NeoBundle 'taglist.vim'
	" NeoBundle 'scala'
	
	NeoBundle 'bling/vim-airline'
    let g:airline_theme='light'
	let g:airline_powerline_fonts=0

	NeoBundle 'git://github.com/t9md/vim-textmanip'
    NeoBundle 'git://github.com/Shougo/unite.vim'
    NeoBundle 'git://github.com/mattn/gist-vim.git'
    let g:github_token = '4151647577d19ac7624d99fdaf50f85c'
	if v:version >= 702
		NeoBundle 'git://github.com/Shougo/neocomplcache.git'
		" neocomplcache
		let g:neocomplcache_enable_at_startup = 1 " 起動時に有効化
	endif
	filetype plugin indent on "ファイル・タイプ認識を有効にする

	NeoBundle 'kchmck/vim-coffee-script'
	" vimにcoffeeファイルタイプを認識させる
	au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee
	" インデントを設定
	autocmd FileType coffee     setlocal sw=2 sts=2 ts=2 et

	NeoBundle 'nathanaelkane/vim-indent-guides'
    " インデントの深さに色を付ける
    let g:indent_guides_start_level=2
    let g:indent_guides_auto_colors=0
    let g:indent_guides_enable_on_vim_startup=0
    let g:indent_guides_guide_size=1
    
	hi IndentGuidesOdd  ctermbg=white
	hi IndentGuidesEven ctermbg=lightgrey
    au FileType coffee,ruby,javascript,python IndentGuidesEnable
    nmap <silent><Leader>ig <Plug>IndentGuidesToggle

	NeoBundleCheck

	"NERDtreeで隠しファイルを表示する
	let NERDTreeShowHidden=1

	"textmanipのキーバインド設定
	"選択したテキストの移動
	vmap <C-j> <Plug>(textmanip-move-down) 
	vmap <C-k> <Plug>(textmanip-move-up) 
	vmap <C-h> <Plug>(textmanip-move-left) 
	vmap <C-l> <Plug>(textmanip-move-right)

	"行の複製
	vmap <M-d> <Plug>(textmanip-duplicate-down)
	nmap <M-d> <Plug>(textmanip-duplicate-down)

endif

augroup MyDev
	autocmd!
	autocmd FileType html,htm set sw=2 | set ts=2 | set sts=2 | set et | set iskeyword+=/
	autocmd FileType cs set sw=2 | set ts=2 | set sts=2 | set et | set iskeyword+=,_,#
	autocmd FileType jade set noet | set iskeyword+=-,_,#
	autocmd FileType javascript set sw=4 | set ts=4 | set sts=4 | set et
	autocmd FileType javascript autocmd BufWritePre <buffer> :%s/\s\+$//e
	autocmd FileType snippet set noet
	autocmd BufRead,BufNewFile *.json set filetype=json
augroup END
