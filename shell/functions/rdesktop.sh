
##
# $1: username
# $2: fully destinguished computer name
##
connect_rdesktop(){
    if [ "$1" = "--help" -o "$1" = "-h" ]; then
        cat << EOF
usage: connect_rdesktop <username> <computer>
EOF
        return 
    fi

    local domain=fh-rosenheim.priv
    local resolution=1440x800
    local user=$1
    local computer=$2
    local keyboard=de

    rdesktop -k $keyboard -u ${computer%%.*}\\$user -d $domain -g $resolution -p - $computer

    return 0
}

##
# $1: username
# $2: fully distinguished computer name
# $2: path (local) to share with the server
##
connect_rdesktop_+share(){
    if [ "$1" = "--help" -o "$1" = "-h" ]; then
        cat << EOF
usage: connect_rdesktop_+share <username> <computer> <local_path_to_share>
EOF
        return 
    fi 

    local domain=fh-rosenheim.priv
    local resolution=1440x800
    local user=$1
    local computer=$2
    local keyboard=de
    local share_path="$3"

    rdesktop -k $keyboard -u ${computer%%.*}\\$user -d $domain -g $resolution -p - $computer -r disk:rdp_share="$3"

    return 0
}
