# SSH auto-completion based on entries in known_hosts.
# This requires hashing to be turned off
if [[ -e ~/.ssh/known_hosts ]]; then
   complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq )" ssh scp sftp
fi