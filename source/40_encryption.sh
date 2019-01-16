#!/usr/bin/env bash

[[ -z "${VAULT_TOKEN}" ]] && export VAULT_TOKEN=$(cat "${HOME}/.vault-token")

function encode() {
    usage="$FUNCNAME 'string' <filename> # encrypt a string or file with aws kms"
    if [[ $# -ne 2 ]]; then
        echo "$FUNCNAME expects two arguments"
        echo $usage
        return 1
    fi
  
    if [[ -s "${1}" ]]; then
        TEXT=$(cat "${1}")
    else
        TEXT="${1}"
    fi

    aws --profile prod kms encrypt \
    --key-id $kmskey \
    --plaintext "${TEXT}" \
    --query CiphertextBlob --output text | base64 --decode \
    > "${2}"
}

function decode() {
    usage="$FUNCNAME <filename> # decrypt a file with aws kms"
    if [[ $# -ne 1 ]]; then
        echo "$FUNCNAME expects one argument"
        echo $usage
        return 1
    fi
    aws --profile prod kms decrypt \
    --ciphertext-blob "fileb://${1}" \
    --output text --query Plaintext | base64 --decode
    echo
}

function decrypt {
    usage="$FUNCNAME <filename> # decrypt a file with gpg and the ldap gpg password"

    /usr/local/bin/gpg -d --no-tty --passphrase-file /Users/mglover/.ldapbackuppass $1
}

function decrypt-bamboo {
    usage="$FUNCNAME <filename> [outputfile] # decrypt a docker config file with gpg"
    if [[ $# -ne 1 ]]; then
        echo $usage
        return 1
    fi
    local filename=$1
    local passphrase=$(vault kv get --field=value secret/internal/utils/bamboo-gpg)
    if [[ -z $2 ]]; then
        local output=$(basename ${filename//.gpg/})
    else
        output=$2
    fi
    
    gpg --decrypt --passphrase "$passphrase" --batch -o "$output" "$filename"
}



function cr {
    curl -s \
        -H "X-Vault-Token: $VAULT_TOKEN" \
        $VAULT_ADDR/v1/cubbyhole/$1 \
        | jq -r '.data.value'
}

function v {
    set | grep "^v.*$" | cut -d" " -f1
}

# vault secret convenience functions
function vls {
    # list and retrieve secrets with the same command
    vault kv list "secret/${1}" 2> /dev/null

    # if we couldn't list that path, it may be a secret - try to retrieve it
    if [[ $? -ne 0 ]]; then
        json=$(vault kv get --format=json "secret/${1}")

        # show key/value pairs
        echo "${json}" | jq -r '.data.data | to_entries[] | "\(.key): \(.value)"'

        # copy the 'value' field to the MacOS pasteboard
        echo "${json}" | jq -r '.data.data.value' | tr -d '\n' | pbcopy        
    fi
}

function vget {
    if [[ "$#" -lt 1 ]]; then
        echo "missing argument"
        return
    fi
    vault kv get "secret/${1}"
}

function vput {
    if [[ "$#" -lt 1 ]]; then
        echo "missing argument"
        return
    fi
    vpath="${1}"
    shift
    vault kv put "secret/$vpath" $@
}

function vrm {
    # remove a secret from vault
    if [[ "$#" -lt 1 ]]; then
        echo "missing argument"
        return
    fi
    vault kv metadata delete "secret/$1"
}

function vcp {
    # copy a vault secret to a new endpoint
    if [[ "$#" -lt 2 ]]; then
        echo "copy a secret to a new endpoint in vault - needs two arguments"
        echo "${0} path/to/secret path/to/new/secret"
        return
    fi

    json=$(curl -s -k \
    -H "X-Vault-Token: ${VAULT_TOKEN}" \
    "${VAULT_ADDR}/v1/secret/data/${1}" \
    | jq '{data: .data.data}')

    curl -k -X POST \
    -H "X-Vault-Token: ${VAULT_TOKEN}" \
    --data @<(echo "${json}") \
    "$VAULT_ADDR/v1/secret/data/${2}"
}

function vmv {
    # copy a secret to an new endpoint and remove the original
    if [[ "$#" -lt 2 ]]; then
        echo "move a secret to a new endpoint in vault - needs two arguments"
        echo "${0} path/to/secret new/path/for/secret"
        return
    fi
    
    vcp "${1}" "${2}" && vrm "${1}"
}


function slateencode {
    local filename=$1
    if [[ -z $2 ]]; then
        local output="$(basename $filename).gpg"
    else
        output=$2
    fi
    local passphrase=$(vault kv get --field=value secret/internal/utils/cleanslate)
    gpg --passphrase "$passphrase" --batch -c -o $output "$filename"
}


function slatedecode {
    local filename=$1
    local passphrase=$(vault kv get --field=value secret/internal/utils/cleanslate)
    if [[ -z $2 ]]; then
        local output=$(basename ${filename//.gpg/})
    else
        output=$2
    fi
    
    gpg --decrypt --passphrase "$passphrase" --batch -o "$output" "$filename"
}

function mkpass {
    password=$(gshuf -n 3 /usr/share/dict/words | gsed 's/./\u&/' | tr -cd '[A-Za-z]'; echo $(gshuf -i0-999 -n 1))
    [[ $1 != "-m" ]] &&  echo "${password}" | pbcopy
    echo "${password}"
}

function onetimesecret {
    if [[ -z $1 ]]; then
        password=$(mkpass -m)
    else
        password=$1
    fi

    ttl="604800"
    onetimeuser="$(vault read --field=user cubbyhole/onetimesecret)"
    onetimekey="$(vault read --field=value cubbyhole/onetimesecret)"

    json=$(curl -s -d "secret=$password&ttl=$ttl" \
     -u "$onetimeuser:$onetimekey" \
     https://onetimesecret.com/api/v1/share)

    secret=$(echo $json | jq -r '.secret_key')
    metadata=$(echo $json | jq -r '.metadata_key')

    echo "password:    $password"
    echo "secret:      https://onetimesecret.com/secret/$secret"
    echo "metadata:    https://onetimesecret.com/private/$metadata"
}
