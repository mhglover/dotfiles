# Editing

if [[ $(lsb_release -a 2> /dev/null | grep Release | cut -f 2) == "7\.04" ]]; then
  #an old version of Ubuntu - specifically optimus
    export EDITOR=$(type vim vi nano pico 2>/dev/null | sed 's/ .*$//;q')
    alias q="$EDITOR"
elif [[ "$SSH_TTY" ]]; then
    #use "subl" for rmate rather than trying to run subl via the alias
    alias subl='rmate'
    export EDITOR=$(type rmate vim vi nano pico 2>/dev/null | sed 's/ .*$//;q')
    alias q="$EDITOR"
    # alias q="$EDITOR -w -z"
    alias sudoq="sudo $HOME/.dotfiles/bin/rmate"

elif [[ "$OSTYPE" =~ ^darwin ]]; then
  #local and on a Mac
  
  #make sure we have an alias for Sublime Text 3
  if [[ -e "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ]] && [[ ! -e "$HOME/bin/subl" ]]; then
    echo "Creating a link for Sublime Text 3"
    if [[ ! -e "$HOME/bin" ]]; then
      mkdir "$HOME/bin"
    fi
    ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
  fi

  export EDITOR='subl -w'
  export LESSEDIT='subl %f'
  alias q='subl'
elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
  # local and on Ubuntu - Enable the use of the `subl` command
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
  alias sudoq="sudo /usr/bin/subl"

elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Mint ]]; then
  # local and on Mint - Enable the use of the `subl` command
  subl () {
      subl_path='/usr/bin/subl'
      if test -t 0
      then
          "$subl_path" $*
      else
          timestamp=`date +%s`
          filename="$1"
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
  alias sudoq="sudo /usr/bin/subl"

else 
  # we're local, but I don't know what system we're on.
    export EDITOR=$(type subl rmate vim vi nano pico 2>/dev/null | sed 's/ .*$//;q')
fi

export VISUAL="$EDITOR"

alias q.='q .'

function qs() {
  pwd | perl -ne"s#^$(echo ~/.dotfiles)## && exit 1" && cd ~/.dotfiles
  q ~/.dotfiles
}

alias diffmerge="/Applications/DiffMerge.app/Contents/Resources/diffmerge.sh"