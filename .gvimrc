"http://dengmao.wordpress.com/2007/01/22/vim-color-scheme-wombat/
colorscheme darkblue "�J���[�X�L�[��

"autocmd Filetype vim :colorscheme blacklight

set columns=100 lines=45 "��ʃT�C�Y


if has('win32')
	let &guifont = iconv('Osaka�|����:h11:cSHIFTJIS', &encoding, 'cp932')
endif


if has('gui_macvim')
	set showtabline=2   "�펞�^�u�\��
	set transparency=10 "�����x
	set imdisable		"�h�b�N�̃A�C�R���o�O�p
else
	gui
	set transparency=230 "�����x
endif

