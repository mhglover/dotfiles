LPASS_AGENT_TIMEOUT='0'

# Lastpass shortcuts

alias l='lpass '
alias lpg='lpass ls | grep -i '
alias lps='lpass show '
alias lph='cat /Users/mglover/.dotfiles/source/70_lastpass.sh'

function lpc() {
    lpass show -c --password "$@" && echo "password copied"
}
