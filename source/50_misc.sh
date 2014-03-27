# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

export GREP_OPTIONS='--color=auto'

# Prevent less from clearing the screen while still showing colors.
export LESS=-XR

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
fi


alias sudo="sudo "  # allows sudo to expand aliases
alias ansible='ansible -u ansible --private-key=~/.ssh/ansible_id_rsa ' #run ansible as the appropriate user

function min {
    if [ "$1" == "" ]; then echo "specify a value"; return; fi
    echo -n "$1" > .config/autokey/data/My\ Phrases/Temporary/min.txt
    export MIN="$1"
}

function mdn {
    if [ "$1" == "" ]; then echo "specify a value"; return; fi
    echo -n "$1" > .config/autokey/data/My\ Phrases/Temporary/mdn.txt
    export MDN="$1"
}

function mip {
    if [ "$1" == "" ]; then echo "specify a value"; return; fi
    echo -n "$1" > .config/autokey/data/My\ Phrases/Temporary/mip.txt
    export MIP="$1"
}

function imsi {
    if [ "$1" == "" ]; then echo "specify a value"; return; fi
    echo -n "$1" > .config/autokey/data/My\ Phrases/Temporary/imsi.txt
    export IMSI="$1"
}
