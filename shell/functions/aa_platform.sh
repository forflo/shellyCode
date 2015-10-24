##
# This function returns the parameters it gets
# dependent on the operating system it runs on
# Param
#   $1: operating system name
#   $2: things to return
#   $3: operating system name
#   $4: things to return
#   $5: operating system name
#   $6: things to return
#   [...]
#     $1, $3 and $5 could be one of {linux, cygwin7, darwin, cygwinxp, others} 
# Return
#   0 on success
#   1 on error
# Return (stdout) if 0 and if $1 is the current os
#   $2
# Usage
#   $ onos linux "fru" cygwin "bla" darwin "ufda" [...]
#   => echo "fru" on linux, echo "bla on cygwin ...
##
sl-onos(){
	local k=1

	if [ -z "$1" -o -z "$2" ] || (($#%2)); then
		return 1
	fi

	case "$(uname -a)" in
		(CYGWIN_NT-6.1*)
			for i in "$@"; do
				((k++)); [[ "${i}" = [Cc]ygwin7 ]] && echo ${!k}
			done ;;
		(CYGWIN_NT-5*)
			for i in "$@"; do
				((k++)); [[ "${i}" = [Cc]ygwinxp ]] && echo ${!k}
			done ;;
		([Ll]inux*)
			for i in "$@"; do
				((k++)); [[ "${i}" = [Ll]inux ]] && echo ${!k}
			done ;;
		(Darwin*)
			for i in "$@"; do
				((k++)); [[ "${i}" = [Dd]arwin ]] && echo ${!k}
			done ;;
		(*)
			for i in "$@"; do
				((k++)); [[ "${i}" = [Oo]thers ]] && echo ${!k}
			done ;;
	esac

    return 0
}

##
# Param
#   $1: one of {cygwin7,cygwinxp,linux,darwin,others}
# Return:
#   0 if $1 describes the current platform, 1 if not
##
sl-onos-ret(){
	case "$(uname -a)" in
		(CYGWIN_NT-6.1*) [ "$1" = [Cc]ygwin7 ] && return 0 || return 1;;
		(CYGWIN_NT-5*) [ "$1" = [Cc]ygwinxp ] && return 0 || return 1;;
		([Ll]inux*) [[ "$1" = [Ll]inux ]] && return 0 || return 1;;
		([Dd]arwin*) [ "$1" = [Dd]arwin ] && return 0 || return 1;;
		(*) [ "$1" = [Oo]thers ] && return 0 || return 1;; 
	esac
}

##
# Derived from onos() but executes the given parameters
# Param, Return
# Return (stdout) 
#   (see the actual executed command)
# Usage
#   $ onos_exec linux "htop" cygwin "echo not installed" linux "top"
#   => subsequently executes htop and then top
##
sl-onos-exec(){
	local command=$(sl-onos "$@")
	eval "$command"
	return 0
}
