#!/usr/bin/env bash

PATH=$HOME/.local/bin:$HOME/.dotfiles/bin:$HOME/bin:/usr/local/sbin:~/.chefdk/gem/ruby/2.3.0/bin:$PATH
export PATH


if [ -f ~/.bashrc ]; then
  time source ~/.bashrc
fi
