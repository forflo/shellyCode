##
# Evaluate with a custom temporary umask
##
# Param:
#   $1: umask
#   $2: command
# Return: 
# Return value of the command
#   1 if wrong parameters were given
##
sl-permcustom(){
	if [ "$1" = "--help" -o "$1" = "-h" ]; then
		cat << EOL
usage: sl-permcustom <temporary-umask> <command>
EOL
		return 0
	fi

	local res
	umask "$1"
	shift
	"$@"
	result=$?
	#UMASK_STD is set by the environment
	umask ${UMASK_STD}

	return $res
}

##
# Waits until a statement succeeds or a timeout
# occurs
##
# Param:
#   $1: timeout in sec
#   $2: condition command(s)
# Return:
#   1 if the timeout occured or
#   0 if the command executed successfully
##
sl-timeout-wait(){
	if [ "$1" = "--help" -o "$1" = "-h" ]; then
		cat << EOL
usage: sl-timeout-wait <timeout-in-sec> <condition commands>
EOL
	fi

	local timeout=${1}
	(( timeout *= 5 ))
	shift
	until eval "$*"; do
		(( timeout-- > 0 )) || return 1
		sleep 0.2
	done
	return 0
}
