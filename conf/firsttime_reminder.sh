# This file is sourced at the end of a first-time dotfiles install.
shopt -s expand_aliases # Aliases are not expanded when the shell is not interactive, unless this is set
source ~/.bashrc

# I'm forgetful. Just look at this repo's commits to see how many times I
# forgot to setup Git and GitHub.

cat <<EOF
If this is a remote server, run:
ssh-copy-id $USER@$(wanip) && ssh $USER@$(wanip)
EOF
