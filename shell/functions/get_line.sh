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
get_line(){
	[ $# -ne 2 ] && clog 1  Parameter fehlen! && return 1
	if [ -f "$1" ]; then
		echo -n "$(head -n $(($2+1)) "$1" | tail -n 1)"
	elif [[ "$1" = "-" ]]; then
		head -n $(($2+1)) | tail -n 1
	else 
		return 1
	fi
	return 0
}
