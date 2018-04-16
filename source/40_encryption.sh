#!/usr/bin/env bash

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

    aws --profile prod \
    kms encrypt \
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
    aws --profile prod \
    kms decrypt \
    --ciphertext-blob "fileb://${1}" \
    --output text --query Plaintext | base64 --decode
    echo
}

function decrypt {
    usage="$FUNCNAME <filename> # decrypt a file with gpg and the ldap gpg password"

    /usr/local/bin/gpg -d --no-tty --passphrase-file /Users/mglover/.ldapbackuppass $1
}