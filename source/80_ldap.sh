#!/usr/bin/env bash

alias daps="ldapsearch $prodldapuser $ldapsearchopts $ldapbase"
alias sudaps="ldapsearch $prodldapadmin $ldapsearchopts $ldapbase"
alias qadaps="ldapsearch $qaldapuser $ldapsearchopts $ldapbase"
alias ldm="ldapmodify $prodldapuser"
alias lda="ldapadd $prodldapuser"
alias sulda="ldapadd $prodldapadmin"
alias qalda="ldapadd $qaldapuser"
alias suqalda="ldapadd $qaldapadmin"
alias qaldm="ldapmodify $qaldapuser"
alias qaldd="ldapdelete $qaldapuser"
alias suqaldd="ldapdelete $qaldapadmin"
alias ldapreminder='set | grep "^ldap\|^prodldap\|^qaldap" ; alias | grep ldap'


function ldd {
    if [[ "$1" == "dn:" ]]; then
        ldapdelete $prodldapuser $2
    else
        ldapdelete $prodldapuser $1
    fi
}

function lds {
    server=$1
    filter=$2
    if [[ $3 == "base" ]]; then
        ldapsearch -H ldap://$server -D uid=mglover,ou=people,dc=carnegielearning,dc=com -x -y $HOME/.ldapprodpw-mglover -LLL -o ldif-wrap=no -b "$filter"
    else
        ldapsearch -H ldap://$server -D uid=mglover,ou=people,dc=carnegielearning,dc=com -x -y $HOME/.ldapprodpw-mglover -LLL -o ldif-wrap=no -b dc=carnegielearning,dc=com "$filter"
    fi

}


export qaldapserver="-H ldap://qaldap"
export qaldapuser="$qaldapserver -D uid=mglover,ou=people,dc=carnegielearning,dc=com -x -y $HOME/.ldapqapw-mglover"
export qaldapadmin="$qaldapserver -D cn=admin,dc=carnegielearning,dc=com -x -y $HOME/.ldapqapw-admin"

export prodldapserver="-H ldap://ldap03.carnegielearning.com"
export prodldaphostroot="$prodldapserver -D cn=hostroot,ou=hosted,dc=carnegielearning,dc=com -x -y $HOME/.ldapprodpw-hostroot"
export prodldapadmin="$prodldapserver -D cn=admin,dc=carnegielearning,dc=com -x -y $HOME/.ldapprodpw-admin"
export prodldapuser="$prodldapserver -D uid=mglover,ou=people,dc=carnegielearning,dc=com -x -y $HOME/.ldapprodpw-mglover"

export ldapsearchopts="-LLL -o ldif-wrap=no"
export ldapbase=" -b dc=carnegielearning,dc=com"

export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCOUNT=732004662672 #qa
export SPOTINST_EMAIL="mglover@carnegielearning.com"
# export SPOTINST_TOKEN="3841869053a8eaaa7cece07de955da17ab60970b112586e163af692a9aac6d16"  # Terraform
export SPOTINST_TOKEN="3516f8d58e007e64c7d68a3c183bcd3669c876e42a9314bd59afba3ff4bc31ec"  # Terraform2
export spotinst_token="3516f8d58e007e64c7d68a3c183bcd3669c876e42a9314bd59afba3ff4bc31ec"  # Terraform2
export spotinst_account_prod="act-6d2bd4cb"
export spotinst_account_qa="act-52dcf17c"
