# Editing

fave="code"

if [[ $(lsb_release -a 2> /dev/null | grep Release | cut -f 2) == "7\.04" ]]; then
  #an old version of Ubuntu - specifically optimus
    export EDITOR=$(type vim vi nano pico 2>/dev/null | sed 's/ .*$//;q')
    alias q="$EDITOR"
elif [[ "$SSH_TTY" ]]; then
    export EDITOR=$(type vim vi nano pico 2>/dev/null | sed 's/ .*$//;q')
    alias q="$EDITOR"

elif [[ "$OSTYPE" =~ ^darwin ]]; then
  #local and on a Mac
  export EDITOR='code'
  alias q='code'
elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
  # local and on Ubuntu - Enable the use of the `subl` command
  export EDITOR='vim'
  export LESSEDIT='vim'
  alias q='vim'
  alias sudoq="sudo vim"

else
  # we're local, but I don't know what system we're on.
    export EDITOR=$(type vim vi nano pico 2>/dev/null | sed 's/ .*$//;q')
fi

export VISUAL="$EDITOR"

alias q.='q .'

function qs() {
  q ~/.dotfiles
}

alias diffmerge="/Applications/DiffMerge.app/Contents/Resources/diffmerge.sh"
