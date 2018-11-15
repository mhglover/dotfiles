#!/usr/bin/env bash
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
  spotinst-cli -g "utility" --replace-ami=${ami} -y
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
  usage="${FUNCNAME} <pattern> [-a prod]"
    if [[ $# -lt 1 ]]; then
        echo "${usage}"
        return 1
    fi
    
  status=$(ecs-roll-status $1 $2 $3)
  while [[ "$status" == *"in_progress"* || "$status" == *"starting"* ]]; do
    echo "$1 - $status"
    sleep 30
    status=$(ecs-roll-status $1 $2 $3)
  done

  echo "$1 - $status"
}

function ecs-roll-status {
  usage="${FUNCNAME} <pattern> [-a prod]"
    if [[ $# -lt 1 ]]; then
        echo "${usage}"
        return 1
    fi
  spotinst-cli --roll-status -g $1 -q -j $2 $3| jq -r '.response.items[0] | "\(.status) - \(.progress.value)%"'
}


function aws-whoami {
  usage="${FUNCNAME} <AWS_ACCESS_KEY_ID> <AWS_SECRET_ACCESS_KEY>"
    if [[ $# -lt 1 ]]; then
        echo "${usage}"
        return 1
    fi

  export AWS_ACCESS_KEY_ID=$1
  export AWS_SECRET_ACCESS_KEY=$2
  aws sts get-caller-identity

  export AWS_ACCESS_KEY_ID=
  export AWS_SECRET_ACCESS_KEY=

}




function aws-impersonate {
  usage="${FUNCNAME} <aws-specific-vaultpath> - without secret/providers/aws/ - example: ${FUNCNAME} qa/migrationengine"
    if [[ $# -lt 1 ]]; then
        echo "${usage}"
        return 1
    fi
  
  json=$(curl -s -k \
    -H "X-Vault-Token: ${VAULT_TOKEN}" \
    "${VAULT_ADDR}/v1/secret/data/providers/aws/${1}" \
    | jq '.data.data')

  key="$(echo "${json}" | jq -r '.access_key')"
  secret="$(echo "${json}" | jq -r '.value')"

  export AWS_ACCESS_KEY_ID=${key}
  export AWS_SECRET_ACCESS_KEY=${secret}
  aws sts get-caller-identity

}


prodldaplb="arn:aws:elasticloadbalancing:us-east-1:560112230788:targetgroup/ldapreplicas/972f762ee6fd106e"


function lblist {

  if [[ ! -z $2 ]]; then
        local profile=$2
    else
      local profile="prod"
    fi

  
  aws elbv2 describe-load-balancers
}


function checklb {
    local arn=$1

    if [[ -z $1 ]]; then
        echo "usage: $0 <arn> [env] # check the status of a load balancer"
        return
    fi

    if [[ ! -z $2 ]]; then
        local profile=$2
    else
      local profile="prod"
    fi

    instances=$(aws --profile $profile elbv2 describe-target-health --target-group-arn "$arn" --query "TargetHealthDescriptions[*].{ID:Target.Id,State:TargetHealth.State}" --output text)
    echo "$instances" | while read instance; do
        id=$(echo $instance | cut -f1 -d" ")
        state=$(echo $instance | cut -f2 -d" ")
        name=$(aws --profile prod ec2 describe-instances --instance-ids $id --query 'Reservations[].Instances[].Tags[?Key==`Name`].Value' --output text)
        echo -e "$id\t\t$state\t\t$name"
    done
}


function registerlb {
    local arn=$1
    local hostname=$2
    if [[ -z $hostname ]]; then
        echo "usage: $0 <arn> <hostname> # register an instance to a load balancer"
        exit 1
    fi

    local instanceid=$(aws --profile prod ec2 describe-instances --filters "Name=tag:Name,Values=*$hostname*" --output text --query 'Reservations[*].Instances[*].InstanceId')

    if [[ "$instanceid" == "" ]]; then
        echo "no instance matching that hostname found in production"
        return
    fi
    echo "registering instance id [$instanceid] with target group [$arn]"
    aws --profile $profile elbv2 register-targets  --target-group-arn "$arn" --targets Id="$instanceid"
}


function deregisterlb {
  local arn=$1
  local hostname=$2

  if [[ -z $hostname ]]; then
      echo "usage: $0 <arn> <hostname> # deregister an instance from a load balancer"
      return
  fi

    local instanceid=$(aws --profile prod ec2 describe-instances --filters "Name=tag:Name,Values=*$hostname*" --output text --query 'Reservations[*].Instances[*].InstanceId')

    if [[ "$instanceid" == "" ]]; then
        echo "no instance matching that hostname found in production"
        return
    fi

    aws --profile prod elbv2 deregister-targets  --target-group-arn "$arn" --targets Id="$instanceid"
}


