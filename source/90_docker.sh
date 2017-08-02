alias d="docker"

function docker-login () {
    $(aws ecr get-login --no-include-email)
}

function docker-login-prod () {
  $(aws --profile prod ecr get-login --no-include-email)
}

alias dockerclean="docker container prune -f ; docker volume prune -f ; docker images | grep none.*none | awk '{print $3}' | while read image; do docker rmi $image ;done"