#mods
function mod_new(){
    if [ -z "$1" ]; then
        echo more arguments!
        return 1
    fi

    local new=~/repos/git/shellyCode/shell/functions/$1.sh
    echo \#$1 > $new
    vim $new
    return
}

function mod_list(){
    for i in ~/repos/git/shellyCode/shell/functions/*; do
        echo $i
    done

    return
}

function func_list(){
    declare -f | grep "[[:alnum:]_-]*\ \(\)"
}

function func_show(){
    if [ -z "$1" ]; then
        echo more arguments!
        return 1
    fi

    declare -f $1 2> /dev/null || {
        echo $1 is not defined
    }

    return
}

