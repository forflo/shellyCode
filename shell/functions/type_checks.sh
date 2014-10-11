##
# Autor: Florian Mayer
# Datum: 19.Sept.2013
# Zweck: Stellt Funktionen bereit, mit denen
# leicht Typüberprüfungen - z.B. für das Parsen von
# Kommandozeilen-Argumenten - durchgeführt werden können
#
# Die einzelnen Funktionen überprüfen je nach Namen entsprechend
# den ersten Parameter. Wenn der Typ zutrifft wird - wie es die 
# Konvention fordert - null zurückgegeben. Im Umkehrschluss 1!
##

##
# Checks if the parameter is an integer
# Param:
#   $1: Value for checking
# Return:
#   0: Its an int
#   1: Its not an int
##
is_int(){
	if [ $# -ne 1 ]; then
		return 1
	fi
	echo " $1 " | grep -e '\<[0-9]+\>' > /dev/null
	return $? 
}

##
# 0 if $1 matches [a-zA-Z0-9]+
##
is_alnum_only(){
	if [ $# -ne 1 ]; then
		return 1
	fi
	echo "$1" | grep -e '\<[a-zA-Z0-9]+\>'  > /dev/null
	return $? 
}

##
# until now just the following regex is matched against
# the string lying inside of $1: [0-9]+(,[0-9]+)?
##
is_decimal(){
	if [ $# -ne 1 ]; then
		return 1
	fi
	echo "$1" | grep -e '\<[1-9][0-9]*(,[0-9]+)?\>'  /dev/null
	return $? 
}

is_ip_address(){
	if [ $# -ne 1 ]; then
		return 1
	fi
	echo "$1" | grep -e '([0-9]|[0-9][0-9]|[1-2][0-5][0-5]\.){3}[0-9]|[0-9][0-9]|[1-2][0-5][0-5]'
	return $? 
}

is_mac_address(){
	if [ $# -ne 1 ]; then
		return 1
	fi
	echo "$1" | grep -e '([0-9a-fA-F][0-9a-fA-F]:){5}[a-fA-F0-9][A-Fa-f0-9]'
	return $? 
}

##
# Checks if a variable denotes a positive
# truth value
# Params:
#   $1: The variable to check
# Return
#   0 on truth
#   1  on false
#   2 if no valid truth value has 
#		been provided
##
is_yes(){
	case ${1} in
		([Yy][Ee][Ss]|[Tt][Rr][Uu][Ee]|[Oo][Nn]|1)
			return 0
			;;
		([Nn][Oo]|[Ff][Aa][Ll][Ss][Ee]|[Oo][Ff][Ff]|0)
			return 1
			;;
		(*)
			return 2
			;;
	esac
}
