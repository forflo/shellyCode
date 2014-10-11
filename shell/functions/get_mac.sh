#!/bin/bash

##
# Searches for a specified mac address in file "file"
# Param
#   $1: Computername
# Return
#   1 on failure
#   0 on success
# Return (stdout) if Return = 0
#   <mac address>
##
get_mac(){
	local file="$REPO/data/mac.txt"

	local result=$(grep "$1" < $file | awk '{printf "%s", $2}')
	if [ -n "result" ]; then
		echo $result
		return 0
	else
		return 1
	fi
}

##
# Provides a table view over the computer, their names
# and their mac addresses.
# Return
#   1 on failure (no reason for that)
#   0 on success
# Param
#   none
##
list_mac(){
	local file="$REPO/data/mac.txt"

	echo -e "[Name] => [Mac]"
	echo "+-------------+"
	while read i; do
		echo -e \[$(echo $i | awk '{printf "%s", $1}')\] =\> \
			\[$(echo $i | awk '{printf "%s", $2}')\]
	done < $file
	return 0
}
