if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto -h --group-directories-first'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias subl='subl3 --new-window'
alias open='xdg-open'
alias pdflatex='pdflatex -halt-on-error -synctex=1'
alias tree='tree -C --dirsfirst'
alias watch='watch --color'
alias dropbox='dropbox-cli'
alias subl-profile='subl ~/friedbrice/dotfiles'
alias ghc='ghc -dynamic' # because haskell is dynamically linked in arch linux
alias npm-all='rm -rf node_modules && rm -rf bower_components && rm -rf output && npm install && bower install && npm run develop'
alias cp-gen='cp -r ../lumi-powerpuff/web/generated_src/purs/Lumi/* src/__generated__/'

function cl {
    cd "$@" && ls
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

function file-watch {
    fswatch -0 "$1" | xargs -0 -n 1 -I {} "$2"
}

function sloc {

    COMMENT_MATCHER=''

    case $1 in
        tex )                             COMMENT_MATCHER='/^\s*%/d'    ;;
        elm | hs | purs | sql )           COMMENT_MATCHER='/^\s*--/d'   ;;
        java | js | scala )               COMMENT_MATCHER='/^\s*\/\//d' ;;
        bash | graphql | py | sh | yaml ) COMMENT_MATCHER='/^\s*#/d'    ;;
    esac

    ( find "./$2" -name "*.$1" -print0 \
        | xargs -0 cat \
        | sed '/^\s*$/d' \
        | sed "$COMMENT_MATCHER" \
    ) | wc -l
}
