#
# ~/.bashrc
#

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# parameters for .bash_history
HISTCONTROL=ignoreboth

shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

# resize dynamically
shopt -s checkwinsize

# do lesspipe if it's present
[ -x /usr/bin/lesspipe.sh ] && eval "$(SHELL=/bin/sh lesspipe.sh)"

# set prompt
if [ -f ~/.bash_prompt ]; then
	. ~/.bash_prompt
else
	PS1='[\u@\h \W]\$ '
fi

# aliases
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# bash completion
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi
