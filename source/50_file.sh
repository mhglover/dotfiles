# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

# Mostly always use color output for `ls`
if [[ "$OSTYPE" =~ ^darwin ]]; then
  alias ls="command ls -G"
elif [[ "$OSTYPE" =~ ^solaris ]]; then
  alias ls="command ls -p"
else
  alias ls="command ls --color"
  export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
fi

# Directory listing
if [[ "$(type -P tree)" ]]; then
  #alias ll='tree --dirsfirst -aLpughDFiC 1'
  alias ll='ls -ltr'
  alias lsd='ll -d'
else
  alias ll='ls -latr'
  alias lsd='CLICOLOR_FORCE=1 ll | grep --color=never "^d"'
fi

# Easier navigation: .., ..., -
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

function cd { 
    if [[ $1 == "" ]]; then
        builtin cd
        ls
    else
        builtin cd "$1" && ls
    fi
}
function ccd { builtin cd "$1"; }

# File size
alias fs="stat -f '%z bytes'"
alias df="df -h"

# Recursively delete `.DS_Store` files
alias dsstore="find . -name '*.DS_Store' -type f -ls -delete"

# Aliasing eachdir like this allows you to use aliases/functions as commands.
alias eachdir=". eachdir"

# Create a new directory and enter it
function md() {
  mkdir -p "$@" && cd "$@"
}

# Fast directory switching
# _Z_NO_PROMPT_COMMAND=1
# _Z_DATA=~/.dotfiles/caches/.z
# . ~/.dotfiles/libs/z/z.sh


# Local Ubuntu-only alias for opening the current directory in the file browser
if [[ ! "$SSH_TTY" && "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] ; then
  alias f="xdg-open ."
elif [[ ! "$SSH_TTY" && "$OSTYPE" =~ ^darwin ]] ; then
  alias f='open .'
fi

#quickalias for FUSE mountpoints
alias cdm="cd ~/mounts"

#deploy dotfiles to a host via rsync
df-deploy() {
  if [[ $1 == "" ]] ; then
    echo "usage: df-deploy <hostname> # specify a hostname to rsync dotfiles to"
    return 1
  fi

  #set up ssh login
  ssh-copy-id "$1"

  #sync the files over there
  rsync -a                        \
    --exclude=".git*"             \
    --exclude="cache*"            \
    --exclude="backups*"          \
    --exclude="libs/git-extra*"   \
    --exclude="link/.ssh/authorized_keys" \
    .dotfiles/ "$1":.dotfiles/    \

  if [[ $? == 127 ]]; then
    #no rsync on remote host - use tar and scp instead
    tar -C "$HOME" -cf /tmp/df.tar         \
      --exclude=".git*"             \
      --exclude="cache*"            \
      --exclude="backups*"          \
      --exclude="libs/git-extra*"   \
      --exclude="link/.ssh/authorized_keys" \
      ".dotfiles/" \
    && scp /tmp/df.tar "$1": \
    && ssh "$1" tar -xf df.tar && ssh "$1" rm df.tar
  fi

  if [[ $? == 0 ]]; then
    #then run dotfiles-bare to update everything
    ssh "$1" "bash ~/.dotfiles/bin/dotfiles-bare"
    ssh "$1"  #then finally connect
  fi

}

function lesshistory() {
  if [[ $1 == "" ]] ; then
    echo "usage: lesshistory <username> # specify a username to view history from"
    return 1
  fi
  sudo less "$(grep root /etc/passwd | cut -d ":" -f 6)/.bash_history"
}