#!/usr/bin/env bash

export PROJECT_HOME=$HOME/devel

#export JAVA_HOME=$(/usr/libexec/java_home)

function rbwork () {
  # add rubyenv
  eval "$(rbenv init -)"
}

function epoch () {
  e=$(date -r $1)
  echo $e
  echo $e | pbcopy
}


# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

alias grep='grep --color'

# Prevent less from clearing the screen while still showing colors.
export LESS=-XR

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

alias sudo="sudo "  # allows sudo to expand aliases

alias arg='sudo $(history -p \!\!)'


alias allcron='for I in $(getent passwd | cut -f1 -d":"); do echo $I; sudo crontab -lu $I 2>1 ; echo "---------------------" ; done | less'

alias rebound="pkill -HUP unbound"

alias unbound="code /usr/local/etc/unbound/unbound.conf"
