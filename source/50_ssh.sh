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

# Don't just ssh into a box.  If you don't already have your key there,
# copy your key and *then* ssh in.
function ssh { 
    /usr/bin/ssh -o BatchMode=yes $1
    if [[ $? -eq "255" ]]; then
        ssh-copy-id $1
        /usr/bin/ssh -o BatchMode=yes $1
    fi
}

# Or if you absolutely need regular ssh, use the sssh alias
alias sssh="/usr/bin/ssh $1"