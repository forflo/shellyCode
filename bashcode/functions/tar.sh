#tar

##
# Tars all files in the current directory
##
sl-tar-cur(){
	[ "$1" = "--help" -o "$1" = "-h" ] && {
		cat << EOL
usage: sh-tar-cur <name-of-archive>
       => Tars all files in the current dir
          producing the file called <name-of-archive>.tar
EOL
	}

	if [ -z "$1" ]; then
		echo more arguments!
		return
	fi

	tar -c -f $1 *
}
