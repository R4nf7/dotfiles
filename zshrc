#
# aliases
#

# git
alias gc="git commit -m"
alias gs="git status"
alias gps="git push && git push origin develop:staging"
alias gp="git push"

# docker

alias dc="docker-compose"

# exa

alias ll="exa"
alias lla="exa -l"
alias llg="exa -l --git"

# misc

alias cat="bat"

#
# functions
#

### Fast git commit
function git_prepare() {
		if [ -n "$BUFFER" ];
			then
				BUFFER="git add -A; git commit -m \"$BUFFER\" && git push"
		fi

		if [ -z "$BUFFER" ];
			then
				BUFFER="git add -A; git commit -v && git push"
		fi
    zle accept-line
	}
	zle -N git_prepare
	bindkey "^g" git_prepare

#
# Change directory, clear and show new folder contents
#

c() {
    clear;
    echo '';
		cd $1;
		ll;
    echo '';
	}
	alias cd="c"

#
# GBT
#
PROMPT='$(gbt $?)'
export TERM='xterm-256color'
export GBT_CAR_STATUS_FORMAT=' {{ Symbol }} {{ Code }} '
export GBT_CAR_HOSTNAME_BG='default'
export GBT_SEPARATOR="⮀"
# hostname
export GBT_CAR_HOSTNAME_FORMAT='Philipp '
export GBT_CAR_HOSTNAME_
export GBT_CAR_HOSTNAME_SEP=' '
# dir
export GBT_CAR_DIR_DEPTH='3'
export GBT_CAR_DIR_BG='1'
export GBT_CAR_DIR_BG='red'
export GBT_CAR_DIR_FG='white'
# os
export GBT_CAR_OS_FORMAT=' {{ Symbol }} '
export GBT_CAR_OS_BG='default'
export GBT_CAR_OS_NAME='darwin'
export GBT_CAR_OS_DISPLAY='1'
export GBT_CAR_OS_SEP=''
#git
export GBT_CAR_GIT_BG='blue'
export GBT_CAR_GIT_FORMAT=' {{ Icon }} {{ Head }} {{ Status }}{{ Ahead }}{{ Behind }} '
#forwarding
export GBT__HOME='/usr/share/gbt'
source "$GBT__HOME/sources/gbts/cmd/local.sh"
alias docker='gbt_docker'
alias ssh='gbt_ssh'

# fasd
eval "$(fasd --init auto)"

