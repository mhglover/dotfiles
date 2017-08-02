# SSH auto-completion based on entries in known_hosts.
# This requires hashing to be turned off
if [[ -e ~/.ssh/known_hosts ]]; then
   complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq )" ssh scp sftp
fi

alias ssh-no-key="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"
alias sshpassonly="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"
alias bamboossh="ssh -i ~/.ssh/elasticbamboo.pk"
