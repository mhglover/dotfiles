# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
# PATH=/usr/local/bin:$(path_remove /usr/local/bin)
# export PATH

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Make 'less' more.  -- needs homebrew
 eval "$(lesspipe.sh)"  

# Start ScreenSaver. This will lock the screen if locking is enabled.
alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"

#OS X needs a place for ansible
export ANSIBLE_HOSTS=$HOME/Dropbox/etc/ansible/hosts

#alternative colorized file viewer
#alias less="/usr/share/vim/vim73/macros/less.sh"

function lls { builtin cd "$1"; }

# Vagrant completion
if [ -f `brew --prefix`/etc/bash_completion.d/vagrant ]; then
    source `brew --prefix`/etc/bash_completion.d/vagrant
fi
