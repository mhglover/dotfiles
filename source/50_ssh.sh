function ssh-init() {
    #copy id files for passwordless login
    ssh-copy-id $1
    #run the abbreviated dotfiles command
    ssh $1 "bash -c \"$(curl -fsSL https://raw.github.com/mhglover/dotfiles/master/bin/dotfiles-bare)\""
    #connect
    ssh $1
}