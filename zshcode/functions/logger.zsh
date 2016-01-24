##
# Loggs without color
# Param:
#   $1 .. $n: Strings to log on one line
#   | <stdin>: Lines to log
# Return: 
#   0: on success
#   1: on failure
##
sl-blog(){
	[ "$1" = "--help" -o "$1" = "-h" ] && {
		cat << EOL
usage: sl-blog <string_1> ... <string_2>
       => logs stings without color (like echo)

       <command> | sl-blog 
       => logs stdin without color (like cat) 
EOL
		return 0
	}

	if [ "$#" -eq 0 ]; then
        while IFS= read -r i; do
			echo "${i}"
        done
	else
		echo "$@"
	fi

	return 0
}

##
# Loggs with color
# Param:
#   $1: Color code (see tput)
#   $2 .. $n: Strings to log on one line
#   | <stdin>: Lines to log
#   - $1 has to be tput colors
#   - clog uses blog if it's output isn't connected
#		to a terminal/pseudo-terminal
#   - If only the color code is used, every further
#		arguments are ignored and stdin is considered to be
#		the log message provider
#   - If the number of positional parameters is greater than 1
#		they are considered as log messages
# Return: 
#   0: on success
#   1: on failure
##
sl-clog(){
	[ "$1" = "--help" -o "$1" = "-h" ] && {
		cat << EOL
usage: sl-clog <tput-color-code> <string_1> ... <string_n>
       => writes colorized sting_1 to string_n to stdout

       <command> | sl-clog <tput-color-code>
       => colorizes everything coming from stdin
EOL
		return 0	
	}

	# only colorization if stdout referes to a terminal!
	if [ -t 1 ]; then
		# stdin is used as log message provider
		if [ "$#" = 1 ]; then
			# color code valid?
			if [ "$1" -ge 0 -a "$1" -lt $SL_TERM_COLORS ]; then
                while IFS= read -r i; do
					echo "${SL_TERM_COLORS_VALUES[$1]}${i}$SL_TERM_RESET"
                done
				return 0
			else
				echo You have to provide a valid color code!
				return 1
			fi
		elif [ "$#" -gt 1 ]; then
			local colorcode=$1; shift 1
			echo "${SL_TERM_COLORS_VALUES[${colorcode}]}${@}$SL_TERM_RESET"
		fi
	else
		shift 1
		sl-blog $@
	fi
}

##
# Loggs with color and formatting like underlines or
# italic/bold-fonts
# Param:
#   $1: Color code (see tput)
#   $2 .. $n: Strings to log on one line
#   | <stdin>: Lines to log
#   - $1 has to be between $ tput colors
#   - flog uses blog if it's output isn't connected
#		to a terminal/pseudo-terminal
#   - If only the color code is used, every further
#		arguments are ignored and stdin is considered to be
#		the log message provider
#   - If the number of positional parameters is greater than 1
#		they are considered as log messages
# Return: 
#   0: on success
#   1: on failure
##
sl-flog(){
	[ "$1" = "--help" -o "$1" = "-h" ] && {
		cat << EOL
usage: sl-flog <tput-color-code> <formatcode_1> ... <formatcode_i> 
               <string> ... <string_n>
       => writes colorized and formated sting_1 to string_n to stdout

       <command> | sl-clog <tput-color-code> <formatcode_1> ... <formatcode_i>
       => colorizes and formats everything coming from stdin
EOL
		return 0	
	}
	
	local color="${SL_TERM_COLORS_VALUES[$1]}"
    local inpipe="false"
	local format=""
	local count=0

	# check color code
	if [ "$1" -ge 0 -a "$1" -lt $SL_TERM_COLORS ]; then
		shift 1
	else
		color=""
		shift 1
	fi

	if [ "$#" -gt 0 ]; then
		# parse format codes, no error detection 
		for i in $@; do
			case "$i" in
				(bold) format=$SL_TERM_BOLD ;;
				(blink) format=$SL_TERM_BLINK ;;
				(underline) format=$SL_TERM_UNDERLINE ;;
				(dim) format=$SL_TERM_DIM ;;
				(negative) format=$SL_TERM_NEGATIVE ;;
                (inpipe) inpipe="true" ;;
				(*)	break ;;
			esac
			((count++))
		done
		shift $count
	fi

	# only color sequences if stdin outputs to a terminal
	if [ -t 1 -o "$inpipe" = "true" ]; then 
		if [ "$#" = 0 ]; then
			# take arguments from stdin
            while IFS= read -r i; do
				echo "${color}${format}${i}$SL_TERM_RESET"
            done
		elif [ "$#" -gt 0 ]; then
			# take arguments from $3 - $#
			echo "${format}${color}${@}$SL_TERM_RESET"
		else
			echo Sie müssen einen Farbcode und einen Formatcode angeben >&2 
			return 1
		fi
	else
		sl-blog "$@"
	fi

	return 0
}

# logs a string 
sl-rlog(){
	[ "$1" = "--help" -o "$1" = "-h" ] && {
		cat << EOL
usage: sl-rlog <tput-color-code> <formatcode_1> ... <formatcode_i> <regex>
               <string> ... <string_n>
       => writes colorized and formated strings matching regex to stdout

       <command> | sl-clog <tput-color-code> <formatcode_1> ... <formatcode_i>
       => colorizes and formats everything coming from stdin
EOL
		return 0	
	}

	local color="${SL_TERM_COLORS_VALUES[$1]}"
	local format=""
    local inpipe="false"
	local regex=""
	local count=0

	# check color code
	if [ "$1" -ge 0 -a "$1" -lt $SL_TERM_COLORS ]; then
		shift 1
	else
		color=""
		shift 1
	fi

	if [ "$#" -gt 0 ]; then
		# parse format codes, no error detection 
		for i in $@; do
			case "$i" in
				(bold) format+=$SL_TERM_BOLD ;;
				(blink) format+=$SL_TERM_BLINK ;;
				(underline) format+=$SL_TERM_UNDERLINE ;;
				(dim) format+=$SL_TERM_DIM ;;
				(negative) format+=$SL_TERM_NEGATIVE ;;
                (inpipe) inpipe="true" ;;
				(*) 	
					break ;;
			esac
			((count++))
		done
		shift $count
	fi

	regex="$1"
	shift 1

	# only color sequences if stdin outputs to a terminal
	if [ -t 1 -o "$inpipe" = "true" ]; then 
		if [ "$#" = 0 ]; then
			# take arguments from stdin
			sed -e "s/\($regex\)/${format}${color}\1$SL_TERM_RESET/g" 
		elif [ "$#" -gt 0 ]; then
			# take arguments from $3 - $#
			echo "$@" | sed -e "s/\($regex\)/${format}${color}\1$SL_TERM_RESET/g" 
		else
			echo You have to provide a valide color code!
			return 1
		fi
	else
		sl-blog $@
	fi
}
