"http://dengmao.wordpress.com/2007/01/22/vim-color-scheme-wombat/
colorscheme darkblue "カラースキーム

"autocmd Filetype vim :colorscheme blacklight

set columns=100 lines=45 "画面サイズ


if has('win32')
	let &guifont = iconv('Osaka－等幅:h11:cSHIFTJIS', &encoding, 'cp932')
endif


if has('gui_macvim')
	set showtabline=2   "常時タブ表示
	set transparency=10 "透明度
	set imdisable		"ドックのアイコンバグ用
else
	gui
	set transparency=230 "透明度
endif

