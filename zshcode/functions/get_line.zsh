#!/bin/bash

##
# Gets a single line of a specified file
# Param
#   $1: filename
#   $2: line number
# Return
#   0 on success
#   1 on failure 
# Return (stdout) if Return = 0
#   <one line of the file>
##
sl-get-line(){
	[ "$1" = "--help" -o "$1" = "-h" ] && { 
		cat << EOL
usage: sl-get-line <filename> <line-number>
EOL
		return 0
	}

	if [ -f "$1" ]; then
		sl-clog "$(head -n $(($2+1)) "$1" | tail -n 1)"
	elif [[ "$1" = "-" ]]; then
		head -n $(($2+1)) | tail -n 1 | sl-clog
	else 
		return 1
		sl-clog 2 "Wrong argument"
	fi
	return 0
}
