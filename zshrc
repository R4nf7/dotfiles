#
# Misc
#
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
PROMPT='$(gbt $?)'

#
# GBT
#
export GBT_CAR_HOSTNAME_BG='default'
export GBT_CAR_HOSTNAME_FORMAT='{{ User }} '
export GBT_CAR_OS_BG='default'
export GBT_VAR_DIR_SEP=''
export GBT_CAR_DIR_BG='88'
export GBT_CAR_OS_SEP=' '
export GBT_CAR_HOSTNAME_SEP='⟫ '
export GBT_CAR_GIT_BG='blue'
#git
export GBT_CAR_GIT_BG='blue'
export GBT_CAR_GIT_FORMAT=' {{ Icon }} {{ Head }} {{ Status }}{{ Ahead }}{{ Behind }} '



#
# Aliases and keybindings
#

#docker
alias dc='docker-compose'

#exa
alias lls='exa'
alias lla='exa -l'
alias llg='exa -l --git'

# fzf
function vim_fzf() {
        vim $(fzf --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200')
	zle end-of-line
	zle accept-line
}
zle -N vim_fzf
bindkey "^p" vim_fzf

#git
alias gc='git commit -m'
alias gs='git status'
alias gp='git push'
alias gd='git diff'
alias gch='git checkout'

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
		lls;
    echo '';
	}
alias cd="c"


#
# Git configs
#
git config --global color.ui true

git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"

git config --global color.diff.meta       "yellow"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"
#use diff-so-fancyt diff
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"


# fasd
eval "$(fasd --init auto)"
