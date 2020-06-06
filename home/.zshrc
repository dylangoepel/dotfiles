export ZSH=$HOME"/.oh-my-zsh"
export PATH=$PATH:~/.local/bin:~/go/bin
export BROWSER=firefox
export EDITOR=nvim

if [ ! -d ~/.oh-my-zsh ]
then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_THEME="robbyrussell"

DISABLE_AUTO_UPDATE="true"

COMPLETION_WAITING_DOTS="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'

alias vifm='vifm -c ":only"'
alias loadtor="proxychains aria2c -o"
alias load="aria2c -o"

alias cat="bat --style numbers"
