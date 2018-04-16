# SSH auto-completion based on entries in known_hosts.
# This requires hashing to be turned off
if [[ -e ~/.ssh/known_hosts ]]; then
   complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq )" ssh scp sftp
fi

alias ssh-no-key="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"
alias sshpassonly="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"

function mitmreset {
    ln=$1
    sed -i.bak -e "${ln}d" ~/.ssh/known_hosts && echo "removed line ${ln}"
}

function bamboossh {
    ip=$(aws --profile prod ec2 describe-instances --instance-ids $1 --query "Reservations[].Instances[].PrivateIpAddress" --output text)
    echo "ip: $ip"
    ssh -i ~/.ssh/elasticbamboo.pk ec2-user@$ip
}


function ssh-instance {
    if [[ ! -z $2 ]]; then
        profile="--profile $2"
    else
        profile=""
    fi
    ip=$(aws $profile ec2 describe-instances --instance-ids $1 --query "Reservations[].Instances[].PrivateIpAddress" --output text)
    echo "ip: $ip"
    ssh $ip
}