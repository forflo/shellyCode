##
# Evaluate with a custom temporary umask
##
# Param:
#   $1: umaks
#   $2: command
# Return: 
# Return value of the command
#   1 if wrong parameters were given
##
do_permcustom(){
	local res
	umask "$1"
	shift
	"$@"
	result=$?
	#UMASK_STD is set by the environment
	umask ${UMASK_STD}
	return $res
}

do_permcustom_sudo(){
	local res
	umask "$1"
	shift
	sudo "$@"
	result=$?
	umask ${UMASK_STD}
	return $res
}

##
# Waits until a statement succeeds or a timeout
# occurs
##
# Param:
#   $1: timeout in sec
#   $2: contition command(s)
# Return:
#   1 if the timeout occured or
#   0 if the command executed successfully
##
timeout_wait(){
	local timeout=${1}
	(( timeout *= 5 ))
	shift
	until eval "$*"; do
		(( timeout-- > 0 )) || return 1
		sleep 0.2
	done
	return 0
}

