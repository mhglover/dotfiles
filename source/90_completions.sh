# Enable AWS CLI completion
complete -C '/usr/local/bin/aws_completer' aws

# Vagrant completion
if [ -f `brew --prefix`/etc/bash_completion.d/vagrant ]; then
    source `brew --prefix`/etc/bash_completion.d/vagrant
fi
