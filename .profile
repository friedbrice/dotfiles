# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's cabal-install bin if it exists
if [ -d "$HOME/.cabal/bin" ]; then
	PATH="$HOME/.cabal/bin:$PATH"
fi

# install NPM packages at user-level instead of system level
if [ -d "$HOME/.npm-packages" ]; then
	NPM_PACKAGES="${HOME}/.npm-packages"
	PATH="$NPM_PACKAGES/bin:$PATH"
	unset MANPATH
        export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
fi

# set PATH so it includes user's local bin if it exists
if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi
