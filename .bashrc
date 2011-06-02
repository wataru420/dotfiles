# .bashrc

# use zsh
if [ -f /bin/zsh ]; then
	exec /bin/zsh
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

#-iで確認 -vで詳細情報の表示
alias cp='cp -iv'
alias rm='rm -iv'
alias mv='mv -iv'

# プロンプトにマシン名(\h)とカレントのフルパス(\w)を表示)
#PS1='[\h]\w $ '

PS1="[\u@\h \W]# "
if [ -f /etc/bashrc ]; then . /etc/bashrc; fi
if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi

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
if [ "$TERM" = "screen" ]; then
  alias ssh=ssh_screen
fi

