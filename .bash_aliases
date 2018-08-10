export EDITOR=vim
export PAGER=most
export VISUAL=subl3
export BROWSER=chromium

function git-containts {
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
        tex ) COMMENT_MATCHER='/^\s*%/d' ;;
        hs | purs | sql ) COMMENT_MATCHER='/^\s*--/d' ;;
        js | java | scala ) COMMENT_MATCHER='/^\s*\/\//d' ;;
        py | sh | bash | graphql | yaml ) COMMENT_MATCHER='/^\s*#/d' ;;
    esac

    ( find ./$2 -name "*.$1" -print0 \
        | xargs -0 cat \
        | sed '/^\s*$/d' \
        | sed "$COMMENT_MATCHER" \
    ) | wc -l
}

alias subl='subl3'
alias open='xdg-open'
alias pdflatex='pdflatex -halt-on-error -synctex=1'
alias tree='tree -C --dirsfirst'
alias watch='watch --color'
