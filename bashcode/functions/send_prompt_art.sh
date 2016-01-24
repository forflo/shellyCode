##
# Autor: Florian Mayer
# Datum: 19.Sept
# Zweck: Verwendet die Funktion prompt_art
# um auf beliebigen tty-Geräten eine Flut von
# ASCII-Art in verschiedensten Farbvariationen
# anzuzeigen
##

##
# $1: fully qualified path of the destination tty
# 	There are some distinctions though:
# $2: wait time between the single lines 
##
send_prompt_art(){
	if [[ ! $# = 2 || -z "$1" || -z "$2" ]]; then
		clog 1 Es ist ein Fehler beim Parsen der Argumente aufgetreten!
		clog 1 "exit!..."
		return 1
	fi

	local pa_time=$2
	local pa_path=$1
	
	while :; do
		sleep $pa_time
	done
	
}
