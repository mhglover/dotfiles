# Editing

if [[ ! "$SSH_TTY" && "$OSTYPE" =~ ^darwin ]]; then
  export EDITOR='subl -w'
  export LESSEDIT='subl %f'
  alias q='subl'
else
    #use "subl" for rmate rather than trying to run subl via the alias
    alias subl='rmate'
    export EDITOR=$(type rmate vim vi nano pico 2>/dev/null | sed 's/ .*$//;q')
    alias q="$EDITOR"
    
    # alias q="$EDITOR -w -z"
fi

export VISUAL="$EDITOR"

alias q.='q .'

function qs() {
  pwd | perl -ne"s#^$(echo ~/.dotfiles)## && exit 1" && cd ~/.dotfiles
  q ~/.dotfiles
}
