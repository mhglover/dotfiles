alias daps="ldapsearch  $prodldapuser $ldapsearchopts $ldapbase"
alias sudaps="ldapsearch  $prodldapadmin $ldapsearchopts $ldapbase"
alias qadaps="ldapsearch  $qaldapuser $ldapsearchopts $ldapbase"
alias ldm="ldapmodify $prodldapuser"
alias lda="ldapadd $prodldapuser"
alias qalda="ldapadd $qaldapuser"
alias qaldm="ldapmodify $qaldapuser"
alias qaldd="ldapdelete $qaldapuser"
alias ldapreminder='set | grep "^ldap\|^prodldap\|^qaldap" ; alias | grep ldap'


function ldd {
    if [[ "$1" == "dn:" ]]; then
        ldapdelete $prodldapuser $2
    else
        ldapdelete $prodldapuser $1
    fi
}