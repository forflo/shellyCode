## 
# Returns a number between 0 and $1. $1 exclusive
# Param
#   $1: number > 0
# Return 
#   0 on success
#   1 on failure
##
sl-random-simple(){
	if [ -z "$1" ]; then
		return 1
	else
		echo -n $(($RANDOM % $1))
	fi
	return 0
}

##
# Returns random file from current directory or directory $1
# Param
#   $1: directory 
# Return
#   0 on success
#   1 on failure
##
sl-random-file(){
	local count=0
    local files=()
	for i in *; do
		[ -f $i ] && {
            files[count]="$i"
		    ((count++))
        }
	done

	echo ${files[$(random_simple ${#files[*]})]}
	return 0
}
