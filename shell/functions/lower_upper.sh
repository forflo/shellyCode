upper(){
	if (( $# == 0 )); then
		return 1;
	fi  
	declare -u upper_lower_upper="$*" # wird automatisch als lokal deklariert!
	echo "$upper_lower_upper"
}

lower(){
	if (( $# == 0 )); then
		return 1;
	fi  
	declare -l upper_lower_upper="$*" # wird automatisch als lokal deklariert!
	echo "$upper_lower_upper"
}
