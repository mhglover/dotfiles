# Editing

if [[ ! "$SSH_TTY" && "$OSTYPE" =~ ^darwin ]]; then
  export EDITOR='subl -w'
  export LESSEDIT='subl %f'
  alias q='subl'
elif [[ ! "$SSH_TTY" && "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
  # Enable the use of the `subl` command
  subl () {
      subl_path='/usr/bin/subl'
      if test -t 0
      then
          "$subl_path" $*
      else
          timestamp=`date +%s`
          filename=$1
          shift
          if [ -z $filename ]; then filename=".temp$timestamp" ; fi
          touch "$filename"
          while read data
          do
              echo "$data" >> "$filename"
          done
          "$subl_path" "$filename" $*
          sleep 1
          rm "$filename"
      fi
  }

  export EDITOR='/usr/bin/subl -w'
  export LESSEDIT='/usr/bin/subl %f'
  alias q='/usr/bin/subl'

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