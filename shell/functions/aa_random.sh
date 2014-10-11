## 
# Returns a number between 0 and $1. $1 exclusive
# Param
#   $1: number > 0
# Return 
#   0 on success
#   1 on failure
##
random_simple(){
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
random_file(){
	if [ -z "$1" ]; then
		return 1
	fi

	if [ -d "$1" ]; then
		cd "$1"
	fi
	local count=0
	for i in *; do
		[ -f $i ] && FILES[count]=$i
		((count++))
	done	

	cd $OLDPWD
	echo ${FILES[$(random_simple ${#FILES[*]})]}
	return 0
}
