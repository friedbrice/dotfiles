# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# parameters for .bash_history
HISTCONTROL=ignoreboth

shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

# resize dynamically
shopt -s checkwinsize

# setup lesspipe
LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1

# set prompt
if [ -f ~/.bash_prompt ]; then
	source ~/.bash_prompt
else
	PS1='[\u@\h \W]\$ '
fi

# aliases
if [ -f ~/.bash_aliases ]; then
	source ~/.bash_aliases
fi

# bash completions

if type brew &>/dev/null; then
	HOMEBREW_PREFIX="$(brew --prefix)"
	if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
		source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
	fi
fi

if [[ -f $(which stack) ]]; then
	eval "$(stack --bash-completion-script stack)"
fi

function makefile_completions {
    local curr_arg;
    local targets;

    # Find makefile targets available in the current directory
    targets=''
    if [[ -e "$(pwd)/Makefile" ]]; then
        targets=$( \
            grep -oE '^[a-zA-Z0-9_-]+:' Makefile \
            | sed 's/://' \
            | tr '\n' ' ' \
        )
    fi

    # Filter targets based on user input to the bash completion
    curr_arg=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "${targets[@]}" -- $curr_arg ) );
}
complete -F makefile_completions make

# brew info bash-completion
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Activate `direnv`: https://direnv.net/
if command -v direnv >/dev/null; then
    eval "$(direnv hook bash)"
fi
