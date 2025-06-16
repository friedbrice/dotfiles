alias ls='ls --color=auto -h --group-directories-first'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias lsblk='diskutil list'

alias pdflatex='pdflatex -halt-on-error -synctex=1'
alias tree='tree -C --dirsfirst'
alias watch='watch --color'
alias code='code --new-window'
alias code-profile='code ~/.profile ~/.bashrc ~/.bash_aliases ~/.bash_prompt ~/.ghci ~/.ssh/config ~/.bindirs ~/.gitconfig'
alias subl='code'
alias subl-profile='code $HOME/friedbrice/dotfiles'
alias regen-bindirs='gfind `brew --prefix`/opt -type d -follow -name gnubin > .bindirs'
alias cat-pdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=merged.pdf'
alias make='make -e'

alias ghci-core='ghci -ddump-simpl -dsuppress-idinfo -dsuppress-coercions -dsuppress-type-applications -dsuppress-uniques -dsuppress-module-prefixes'

alias ghci-core-goose='ghci -ddump-simpl -dsuppress-all -dsuppress-uniques -dno-suppress-type-applications -dno-suppress-type-signatures'

function git-filediff {
  if [ "$#" -eq 2 ]; then
    git --no-pager diff --name-status "$1" "$2"
  elif [ "$#" -eq 1 ]; then
    git --no-pager diff --name-status "$1"
  else
    git --no-pager diff --name-status HEAD
  fi
}

function git-tree {
	tree -I "$(grep -hvE '^$|^#' {~/,,$(git rev-parse --show-toplevel)/}.gitignore|sed 's:/$::'|tr \\n '\|').git" -a $@
}

function git-contains {
	git merge-base --is-ancestor "$1" $(git rev-parse HEAD)
}

function git-parents {
	git log --pretty=%P -n 1 "$1"
}

function git-search {
	git grep "$1" $(git rev-list -all)
}

function grep-for-in {
	grep -rnw "$2" -e "$1"
}

function alert {
	osascript -e "display notification \"$1\" with title \"Alert\""
}

function to-alpha {
	local alpha=$1
	local input=$2
	local output=$3

	local help="usage: \e[1;31mtoAlpha\e[0m \e[92malpha-color\e[0m \e[92minput-file\e[0m \e[92moutput-file\e[0m"
	help+="\n\nalpha-color should be an HTML hex code (include the leading '#')."

	(test $# -eq 3 && (
		magick convert \
			"$input" \
			\( \
			-clone 0 \
			-fill "$alpha" \
			-colorize 100 \
			\) \
			\( \
			-clone 0,1 \
			-compose difference \
			-composite \
			-separate \
			+channel \
			-evaluate-sequence max \
			-auto-level \
			\) \
			-delete 1 \
			-alpha off \
			-compose over \
			-compose copy_opacity \
			-composite \
			"$output"
  )) || (echo -e "$help" && false)
}

function pdf-to-png {
  magick convert -density 192 "$1.pdf" -quality 100 "$1.png"
}
