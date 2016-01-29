if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
export PIP_REQUIRE_VIRTUALENV=true
export VIRTUAL_ENV_DISABLE_PROMPT=1

gpip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}


export WORKON_HOME=$HOME/envs
export PIP_VIRTUALENV_BASE=$WORKON_HOME

export PROJECT_HOME=$HOME/devel
source /usr/local/bin/virtualenvwrapper.sh
alias workoff='deactivate'
