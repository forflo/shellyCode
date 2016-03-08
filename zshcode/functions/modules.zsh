# Module functions
# Create new function files in this directory
sl-mod-new(){
    if [ -z "$1" ]; then
        echo Please specify the module name!!
        return 1
    fi

    local new=$HOME/repos/git/shellyCode/zshcode/functions/$1.sh
    echo \#$1 > $new
    vim $new
    return 0
}

sl-mod-list(){
    for i in $HOME/repos/git/shellyCode/zshcode/functions/*; do
        echo $i
    done

    return 0
}

sl-func-list(){
    declare -f | grep "[[:alnum:]_-]*\ \(\)"
}

sl-func-show(){
    if [ -z "$1" ]; then
        echo more arguments!
        return 1
    fi

    declare -f $1 2> /dev/null || {
        echo $1 is not defined
    }

    return
}

