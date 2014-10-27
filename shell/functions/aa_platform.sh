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
#     $1, $3 and $5 could be one of {linux, cygwin, darwin, archlinux, ubuntu} 
# Return
#   0 on success
#   1 on error
# Return (stdout) if 0 and if $1 is the current os
#   $2
# Usage
#   $ onos linux "fru" cygwin "bla" darwin "ufda" [...]
#   => echo "fru" on linux, echo "bla on cygwin ...
##
onos(){
	if [ -z "$1" -o -z "$2" ] || (($#%2)) ; then
		return 1
	fi
	local k=1
	case "$(uname -a)" in
		(*ARCH*)
			for i in "$@"; do
				((k++))
				[ "${i}" = "archlinux" ] && echo ${!k}
			done
			;;
		(*Ubuntu*)
			for i in "$@"; do
				((k++))
				[ "${i}" = "ubuntulinux" ] && echo ${!k}
			done
			;;
		(CYGWIN_NT-6.1)
			for i in "$@"; do
				((k++))
				[ "${i}" = "cygwin7" ] && echo ${!k}
			done
			;;
		(CYGWIN_NT-5)
			for i in "$@"; do
				((k++))
				[ "${i}" = "cygwinxp" ] && echo ${!k}
			done
			;;
		(Darwin*)
			for i in "$@"; do
				((k++))
				[ "${i}" = darwin ] && echo ${!k}
			done
			;;
	esac
	return 0
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
onos_exec(){
	local command=$(onos "$@")
	eval "$command"
	return 0
}