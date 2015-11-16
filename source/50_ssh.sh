# SSH auto-completion based on entries in known_hosts.
# This requires hashing to be turned off
if [[ -e ~/.ssh/known_hosts ]]; then
   complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq )" ssh scp sftp
fi


#enable ssh autocompletion
# complete -W "$(echo $(grep '^ssh ' ~/.bash_history | sort -u | sed 's/^ssh //'))" ssh


# from http://brettterpstra.com/2013/02/10/the-joy-of-sshfs/
# I never use sshfs anymore
# Remote Mount (sshfs)
# creates mount folder and mounts the remote filesystem
# rmount() {
#     local host folder mname
#     host="${1%%:*}:"
#     [[ ${1%:} == ${host%%:*} ]] && folder='' || folder=${1##*:}
#     if [[ $2 ]]; then
#         mname=$2
#     else
#         mname=${folder##*/}
#         [[ "$mname" == "" ]] && mname=${host%%:*}
#     fi
#     if [[ $(grep -i "host ${host%%:*}" ~/.ssh/config) != '' ]]; then
#         mkdir -p ~/mounts/$mname > /dev/null
#         sshfs $host$folder ~/mounts/$mname -oauto_cache,reconnect,idmap=user,workaround=rename && echo "mounted ~/mounts/$mname"
#     else
#         echo "No entry found for ${host%%:*}"
#         return 1
#     fi
# }

# # Remote Umount, unmounts and deletes local folder (experimental, watch you step)
# rumount() {
#     if [[ $1 == "-a" ]]; then
#         ls -1 ~/mounts/|while read dir
#         do
#             [[ $(mount | grep "mounts/$dir") ]] && umount ~/mounts/$dir
#             [[ $(ls ~/mounts/$dir) ]] || rm -rf ~/mounts/$dir
#         done
#     else
#         [[ $(mount | grep "mounts/$1") ]] && umount ~/mounts/$1
#         [[ $(ls ~/mounts/$1) ]] || rm -rf ~/mounts/$1
#     fi
# }

# Don't just ssh into a box.  Try to use sshrc, check for a key, 
# If you don't already have your key there,
# copy your key and *then* sshrc in.

# Or if you absolutely need regular ssh, use the sssh alias
# alias sssh="/usr/bin/ssh $1"

# function ssh { 
#     if [[ $1 == "prodairman" ]]; then
#         sshcommand="/usr/bin/ssh"
#         #echo "sshing $1"
#     else
#         sshcommand="/Users/mglover/bin/sshrc"
#         #echo "sshrcing $1"
#     fi

#     $sshcommand -o BatchMode=yes $1 
#     if [[ $? -eq "255" ]]; then
#         ssh-copy-id $1
#         sshcommand -o BatchMode=yes $1
#     fi
#     #iterm2_print_state_data
# }

