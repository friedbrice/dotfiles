eval "$(/opt/homebrew/bin/brew shellenv)"

# use up-to-date GNU utilities.
# Generate .bindirs with `gfind /opt/homebrew/opt -type d -follow -name gnubin > .bindirs`
while IFS='' read -r bindir || [ -n "$bindir" ]; do
	PATH="$bindir:$PATH"
done < "$HOME/.bindirs"

BREW_PREFIX=$(brew --prefix)

# use GNU man-db
if [ -d "$BREW_PREFIX/opt/man-db/libexec/bin" ]; then
	PATH="$BREW_PREFIX/opt/man-db/libexec/bin:$PATH"
fi
if [ -d "/usr/local/opt/man-db/libexec/bin" ]; then
	PATH="/usr/local/opt/man-db/libexec/bin:$PATH"
fi

# add local sbin to path
if [ -d "$BREW_PREFIX/sbin" ]; then
	PATH="$BREW_PREFIX/sbin:$PATH"
fi
if [ -d "/usr/local/sbin" ]; then
	PATH="/usr/local/sbin:$PATH"
fi

# install NPM packages at user-level instead of system level
if [ -d "$HOME/.npm-packages" ]; then
	NPM_PACKAGES="$HOME/.npm-packages"
	PATH="$NPM_PACKAGES/bin:$PATH"
	MANPATH="$NPM_PACKAGES/share/man:$MANPATH"
fi

# homebrew caveats

## see `brew info libffi`
if [ -d "$BREW_PREFIX/opt/libffi/lib/pkgconfig" ]; then
	if [ -z $PKG_CONFIG_PATH ]; then
		PKG_CONFIG_PATH="$BREW_PREFIX/opt/libffi/lib/pkgconfig"
	else
		PKG_CONFIG_PATH="$BREW_PREFIX/opt/libffi/lib/pkgconfig:$PKG_CONFIG_PATH"
	fi
fi

## see `brew info python`
if [ -d "$BREW_PREFIX/opt/python/libexec/bin" ]; then
	PATH="$BREW_PREFIX/opt/python/libexec/bin:$PATH"
fi

## see `brew info tcl-tk`
if [ -d "$BREW_PREFIX/opt/tcl-tk" ]; then
	PATH="$BREW_PREFIX/opt/tcl-tk/bin:$PATH"
	PKG_CONFIG_PATH="$BREW_PREFIX/opt/tcl-tk/lib/pkgconfig:$PKG_CONFIG_PATH"
fi

## see `brew info ncurses`
if [ -d "$BREW_PREFIX/opt/ncurses/bin" ]; then
	PATH="$BREW_PREFIX/opt/ncurses/bin:$PATH"
fi

## see `brew info ruby`
if [ -d "$BREW_PREFIX/opt/ruby/bin" ]; then
	PATH="$BREW_PREFIX/opt/ruby/bin:$PATH"
fi

## see `brew info openssl`
if [ -d "$BREW_PREFIX/opt/openssl/bin" ]; then
	PATH="$BREW_PREFIX/opt/openssl/bin:$PATH"
fi

# add various dirs to PATH

if [[ -d "$HOME/.cargo/bin" ]]; then
	PATH="$HOME/.cargo/bin:$PATH"
fi

if [[ -d "$BREW_PREFIX/opt/mysql-client/bin" ]]; then
	PATH="$BREW_PREFIX/opt/mysql-client/bin:$PATH"
fi

if [[ -d "$HOME/.ghcup/bin" ]]; then
	PATH="$HOME/.ghcup/bin:$PATH"
fi

if [ -d "$HOME/.cabal/bin" ]; then
	PATH="$HOME/.cabal/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.bin" ]; then
	PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

# ruby installation instructions from https://jekyllrb.com/docs/installation/macos/
if [ -f "$BREW_PREFIX/opt/chruby/share/chruby/chruby.sh" ]; then
  source "$BREW_PREFIX/opt/chruby/share/chruby/chruby.sh"
fi
if [ -f "source $BREW_PREFIX/opt/chruby/share/chruby/auto.sh" ]; then
  source "source $BREW_PREFIX/opt/chruby/share/chruby/auto.sh"
fi
if [ -f "$BREW_PREFIX/opt/chruby/share/chruby/chruby.sh" ]; then
  source "$BREW_PREFIX/opt/chruby/share/chruby/chruby.sh"
fi
(which chruby && chruby ruby-3.1.3) || true

source ~/.orbstack/shell/init.bash 2>/dev/null || true

# export environment variables
export PATH
export MANPATH
export NPM_PACKAGES
export PKG_CONFIG_PATH
export EDITOR=vim
export VISUAL=vim
export PAGER=most
export MANPAGER=most
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export BASH_SILENCE_DEPRECATION_WARNING=1

# if running bash include .bashrc
if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		source "$HOME/.bashrc"
	fi
fi
