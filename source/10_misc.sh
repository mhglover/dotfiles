export PIP_REQUIRE_VIRTUALENV=true
export VIRTUAL_ENV_DISABLE_PROMPT=1

gpip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}



source /usr/local/bin/virtualenvwrapper.sh