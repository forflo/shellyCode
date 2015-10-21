#tar

##
# Tars all files in the current directory
##
function tar-cur(){
	if [ -z "$1" ]; then
		echo more arguments!
		return
	fi

	tar -c -f $1 *
}
