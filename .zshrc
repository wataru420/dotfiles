export LANG=ja_JP.UTF-8
export JAVA_OPTIONS="-Dfile.encoding=UTF-8"
export MAVEN_OPTS="-Dfile.encoding=UTF-8"

#tmux
case "${OSTYPE}" in
linux*)
	alias tmux="/usr/local/bin/tmux"
	alias tmuxa="/usr/local/bin/tmux a -t"
	;;
frebsd*|darwin*)
	export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
	alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
	alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
	alias tmuxa="tmux a -t"
	;;
esac

#lsの拡張
case "${OSTYPE}" in
frebsd*|darwin*)
	alias ls="ls -G -w"
	;;
linux*)
	eval `dircolors`
	alias ls="ls --color"
	;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -al"

#-iで確認 -vで詳細情報の表示
alias cp='cp -iv'
#alias rm='rm -iv'
alias mv='mv -iv'

# ヒストリー機能
HISTFILE=~/.zsh_history      # ヒストリファイルを指定
HISTSIZE=10000               # ヒストリに保存するコマンド数
SAVEHIST=10000               # ヒストリファイルに保存するコマンド数
setopt hist_ignore_all_dups  # 重複するコマンド行は古い方を削除
setopt hist_ignore_dups      # 直前と同じコマンドラインはヒストリに追加しない
setopt share_history         # コマンド履歴ファイルを共有する
setopt append_history        # 履歴を追加 (毎回 .zsh_history を作るのではなく)
setopt inc_append_history    # 履歴をインクリメンタルに追加
setopt hist_no_store         # historyコマンドは履歴に登録しない
setopt hist_reduce_blanks    # 余分な空白は詰めて記録
#setopt hist_ignore_space    # 先頭がスペースの場合、ヒストリに追加しない)

## コアダンプサイズを制限
limit coredumpsize 102400
## 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr

##Viライクキーバインド設定
bindkey -v

# PROMPT
#PS1="[@${HOST%%.*} %1~]%(!.#.$) "
#RPROMPT="%T"
autoload colors
colors
PROMPT="%{${fg[blue]}%}[%n@%m] %(!.#.$) %{${reset_color}%}"
PROMPT2="%{${fg[blue]}%}%_> %{${reset_color}%}"
SPROMPT="%{${fg[red]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"
RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}%T"
setopt prompt_subst ##色を使う


## 補完機能の強化
autoload -U compinit
compinit

# ディレクトリ名を入力するだけでカレントディレクトリを変更
setopt auto_cd

# タブキー連打で補完候補を順に表示
setopt auto_menu

# 自動修正機能(候補を表示)
setopt correct

# 補完候補を詰めて表示
setopt list_packed

# 補完候補一覧でファイルの種別を識別マーク表示(ls -F の記号)
setopt list_types

# パスの最後に付くスラッシュを自動的に削除しない
setopt noautoremoveslash

# = 以降でも補完できるようにする( --prefix=/usr 等の場合)
setopt magic_equal_subst

# 補完候補リストの日本語を正しく表示
setopt print_eight_bit

# 補完の時に大文字小文字を区別しない(但し、大文字を打った場合は小文字に変換しない)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# lsコマンドの補完候補にも色付き表示
zstyle ':completion:*:default' list-colors ${LS_COLORS}
# kill の候補にも色付き表示
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

#known_hostsからの補完
function print_known_hosts (){
	if [ -f $HOME/.ssh/known_hosts ]; then
		cat $HOME/.ssh/known_hosts | tr ',' ' ' | cut -d' ' -f1
  	fi
}
_cache_hosts=($( print_known_hosts ))

#screenでSSHしたときにwindow名をIPアドレスにする
function ereg(){
    local _reg=$1
    local _text=$2
    echo "${_text}" | grep -E -q "${_reg}"
	if [ $? -ne 0 ]; then
	    return 1
	fi
	return 0
}
			
function check_ipaddres(){
	local _text=$1
    ereg '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "${_text}"
    if [ $? -ne 0 ]; then
        return 1
    fi
    return 0
}
									
function ssh_screen(){
    eval server=\${$#}
    check_ipaddres "${server}" 
    if [ $? -eq 0 ]; then
        server=$(echo ${server})
    else
	    #server=$(echo ${server} | cut -d . -f 1)
        server=$(echo ${server})
    fi
    screen -t ${server} ssh "$@"
}

#sshコマンドをssh_screenでラップする
#if [ "$TERM" = "screen" ]; then
#  alias ssh=ssh_screen
#fi
