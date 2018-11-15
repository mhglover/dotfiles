#!/usr/bin/env bash
# Git shortcuts

alias g='git'
alias gs='git status'

alias st="/Applications/SourceTree.app/Contents/MacOS/Sourcetree 2> /dev/null $(pwd) &"

function qtag {
  export GIT_DIR="$HOME/devel/configs/.git"
  
  if [[ $# -eq 0 ]]; then
    git tag -l | cat
  fi

  if [[ $# -eq 1 ]]; then
    git tag -l | grep $1
  fi

  if [[ $# -eq 2 ]]; then
    tagged=$(git tag -l | grep $1 | grep $2)
    commit=$(git rev-list -n 1 "${tagged}" 2> /dev/null)
    git tag --points-at "${commit}" | grep $1 | cat
  fi

  unset GIT_DIR

}