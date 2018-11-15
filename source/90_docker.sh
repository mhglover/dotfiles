#!/usr/bin/env bash

# docker-compose completion - throws errors
# sudo curl -L https://raw.githubusercontent.com/docker/compose/1.21.0/contrib/completion/bash/docker-compose -o /usr/local/etc/bash_completion.d/docker-compose
# if [ -f $(brew --prefix)/etc/bash_completion ]; then
# . $(brew --prefix)/etc/bash_completion
# fi



alias d="docker"

function docker-login () {
    $(aws ecr get-login --no-include-email)
}

function docker-login-prod () {
  $(aws --profile prod ecr get-login --no-include-email)
}

function dockerclean () {
  docker container prune -f
  docker volume prune -f
  docker images \
    | grep "<none>" \
    | awk '{print $3}' \
    | while read image; do
        docker rmi $image
      done
}

function dockerbash {
  docker exec -it $1 bash
}

# docker image completion
# complete -W "$(docker ps --format "{{.Names}}")" dockerbash
