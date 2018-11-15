#!/usr/bin/env bash

# eval "$(pyenv init -)"
# export PYENV_ROOT=$HOME/.local/bin
export PIP_REQUIRE_VIRTUALENV=true
export VIRTUAL_ENV_DISABLE_PROMPT=1

gpip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

export WORKON_HOME=$HOME/.virtualenvs
export PIP_VIRTUALENV_BASE=$WORKON_HOME

export PROJECT_HOME=$HOME/devel

function pywork () {
  # auto-execute the contents of an .env file in a directory when you cd into it
  source $(brew --prefix autoenv)/activate.sh
  source /usr/local/bin/virtualenvwrapper.sh
  alias workoff='deactivate'
}

