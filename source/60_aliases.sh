# alias last and save
# use `als c NAME` to chop off the last argument (for filenames/patterns)
# from http://brettterpstra.com/2013/08/30/easily-save-that-wicked-awesome-shell-command/
als() {
    local aliasfile chop x
    [[ $# == 0 ]] && echo "Name your alias" && return
    if [[ $1 == "c" ]]; then
        chop=true
        shift
    fi
    aliasfile=~/.dotfiles/source/60_aliases.sh
    touch $aliasfile
    if [[ `cat "$aliasfile" |grep "alias ${1// /}="` != "" ]]; then
        echo "Alias ${1// /} already exists"
    else
        x=`fc -l -2 | sed -e '$!{h;d;}' -e x | sed -e 's/.\{7\}//'`
        if [[ $chop == true ]]; then
            echo "Chopping..."
            x=$(echo $x | rev | cut -d " " -f2- | rev)
        fi
        echo -e "\nalias ${1// /}=\"`echo $x|sed -e 's/ *$//'|sed -e 's/\"/\\\\"/g'`\"" >> $aliasfile && source $aliasfile
        alias $1
    fi
}


alias reissue="ssh prodopwvpspdb2 pass_reissue.py"
