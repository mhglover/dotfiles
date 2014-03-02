function ssh-init() {
    #copy id files for passwordless login
    ssh-copy-id $1
    #run the abbreviated dotfiles command
    ssh $1 "bash -c \"$(curl -fsSL https://raw.github.com/mhglover/dotfiles-bare/master/bin/dotfiles)\""
    #connect
    ssh $1
}