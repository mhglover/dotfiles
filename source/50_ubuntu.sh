# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# Package management
alias update="sudo apt-get -qq update && sudo apt-get upgrade"
alias install="sudo apt-get install"
alias remove="sudo apt-get remove"
alias search="apt-cache search"

# Make 'less' more.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# # Switch between already-downloaded node versions.
# function node_ver() {
#   (
#     ver="${1#v}"
#     nodes=()
#     if [[ ! -e "/usr/local/src/node-v$ver" ]]; then
#       shopt -s extglob
#       shopt -s nullglob
#       cd "/usr/local/src"
#       eval 'for n in node-v*+([0-9]).+([0-9]).+([0-9]); do nodes=("${nodes[@]}" "${n#node-}"); done'
#       [[ "$1" ]] && echo "Node.js version \"$1\" not found."
#       echo "Valid versions are: ${nodes[*]}"
#       [[ "$(type -P node)" ]] && echo "Current version is: $(node --version)"
#       exit 1
#     fi
#     cd "/usr/local/src/node-v$ver"
#     sudo make install >/dev/null 2>&1 &&
#     echo "Node.js $(node --version) installed." ||
#     echo "Error, $(node --version) installed."
#   )
# }
