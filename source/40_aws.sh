export AWS_CREDENTIAL_FILE=~/.aws/credentials

alias jqtask="jq -S '{containerDefinitions: .taskDefinition.containerDefinitions}'"
alias jqnormalize='jq -S '\''def walk(f): . as $in | if type == "object" then reduce keys[] as $key ( {}; . + { ($key):  ($in[$key] | walk(f)) } ) | f elif type == "array" then map( walk(f) ) | f else f end; def normalize: walk(if type == "array" then sort else . end); normalize'\'

function pulltask {
    aws ecs describe-task-definition --task-definition "$1:$2" | jqtask > $1.$2.json
}

function jqsort {
  jq 'def post_recurse(f): def r: (f | select(. != null) | r), .; r; def post_recurse: post_recurse(.[]?); ($a | (post_recurse | arrays) |= sort) as $a | $a' 66
}

function jqcompare {
  comparison=$(jq --argfile a $1 --argfile b $2 -n 'def post_recurse(f): def r: (f | select(. != null) | r), .; r; def post_recurse: post_recurse(.[]?); ($a | (post_recurse | arrays) |= sort) as $a | ($b | (post_recurse | arrays) |= sort) as $b | $a == $b')
  echo $comparison
}

function ecs-image {
  aws ec2 describe-images \
  --filters "Name=owner-alias,Values=amazon" "Name=name,Values=*ecs-optimized*" \
  --query 'Images[?Name!=`null`].[CreationDate,ImageId,Name]' \
  --output text \
  | sort \
  | tail -1 \
  | awk '{print $2}'
}

function ecs-replace-ami {
  ami=$(ecs-image)
  echo "AMI: ${ami}"
  spotinst-cli -g "QA-ECS-blue" --replace-ami=${ami} -y
  spotinst-cli -g "QA-ECS-green" --replace-ami=${ami} -y
  spotinst-cli -g "web-doghouse-spot-01" --replace-ami=${ami} -y
  spotinst-cli -a prod -g "prod-sso-ECS-blue" --replace-ami=${ami} -y
}


function ecs-roll-spot {
  usage="$FUNCNAME '<seconds> <pattern> [environment]' - wait for n seconds, then start rolling a group matching a pattern in an (optional) environment"
  if [[ $# -lt 2 ]]; then
      echo "$FUNCNAME expects two or three arguments"
      echo $usage
      return 1
  fi
  waiter=$1
  color=$2
  if [[ ! -z "${3}" ]]; then
    environ="-a $3"
  fi

  spotinst-cli $environ --roll --grace=100 --batch-size=2 -g $color -y
  echo "waiting ${waiter} seconds for the roll to start"
  sleep ${waiter}
  ecs-roll-status-wait $color $environ

}


function ecs-roll-all-spots {
  echo "rolling all spotinst groups: doghouse, aqa blue, aqa green, prod blue"
  waiter="40"
  ecs-roll-spot ${waiter} dog
  ecs-roll-spot ${waiter} blue
  ecs-roll-spot ${waiter} green
  ecs-roll-spot ${waiter} blue prod  
}

function ecs-roll-status-wait {
  status=$(ecs-roll-status $1 $2 $3)
  while [[ "$status" == *"in_progress"* ]]; do
    echo "$1 - $status"
    sleep 30
    status=$(ecs-roll-status $1 $2 $3)
  done
}

function ecs-roll-status {
  spotinst-cli --roll-status -g $1 -q -j $2 $3| jq -r '.response.items[0] | "\(.status) - \(.progress.value)%"'
}