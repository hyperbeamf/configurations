#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1="[\u@\h \W]\$ " 
alias l="ls --color=auto"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
