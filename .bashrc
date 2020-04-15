#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
# PS1="[\u@\h \W]\$ "
PS1="λ "
alias l="ls --color=auto"
alias acm="9 acme -f /mnt/font/'OfficeCodePro-Medium'/10a/font"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH:$HOME/userscripts"
