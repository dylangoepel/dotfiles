export ZSH="/home/dylan/.oh-my-zsh"
ZSH_THEME="robbyrussell"

DISABLE_AUTO_UPDATE="true"

COMPLETION_WAITING_DOTS="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'

alias vifm='vifm -c ":only"'
