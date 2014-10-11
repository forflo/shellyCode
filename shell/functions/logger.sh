# Autor: Florian Mayer
# Datum: 31.August.2013
#
# For Documentation see $REPO/code/shell/docs
##

LOG_DATEOPTS="+%d.%h.%Y-%H:%M:%S"
LOG_POPEN="["
LOG_PCLOSE="]"

##
# Variables for this module
##
LOG_PROMPT=${POPEN}"$(uname -rs) | $(date $OPTS) | $(tty)"$PCLOSE" "
LOG_PROMPT_FUNC="log_prompt"

log_reset_prompt(){
	LOG_PROMPT_FUNC="log_prompt"
}

log_no_prompt(){
	:
}

log_simple_prompt(){
	echo [log message:]" "
}

log_prompt(){
	echo "$LOG_PROMPT"
}

##
# Loggs without color
# Param:
#   $1 .. $n: Strings to log on one line
#   | <stdin>: Lines to log
# Return: 
#   0: on success
#   1: on failure
##
blog(){
	if [ "$#" -eq 0 ]; then
		mapfile TEXT 
		for ((i=0; i<${#TEXT[@]}; i++)); do
			echo -n "$($LOG_PROMPT_FUNC)${TEXT[i]}"
		done
	else
		echo "$($LOG_PROMPT_FUNC)$@"
	fi
	return 0
}

##
# Loggs with color
# Param:
#   $1: Color code (see tput)
#   $2 .. $n: Strings to log on one line
#   | <stdin>: Lines to log
#   - $1 has to be between $ tput colors
#   - clog uses blog if it's output isn't connected
#		to a terminal/pseudo-terminal
#   - If only the color code is used, every further
#		arguments are ignored and stdin is considered to be
#		the log message provider
#   - If the number of positional parameters is greater than 1
#		they are considered as log messages
# Return: 
#   0: on success
#   1: on fawithoutilure
##
clog(){
	[[ "$#" = 0 ]] || {
		echo Sie müssen einen Farbcode bereitstellen!
		echo Zeile: $LINENO	
		return 1
	}

	# only colorization if stdout referes to a terminal!
	if [ -t 1 ]; then
		# stdin is used as log message provider
		if [ "$#" = 1 ]; then
			# color code valid?
			if [ "$1" -ge 0 -a "$1" -lt $TERM_COLORS ]; then
				mapfile TEXT
				for ((i=0; i<${#TEXT[@]}; i++)); do
					echo -n "$($LOG_PROMPT_FUNC)${TERM_COLORS_VALUES[$1]}${TEXT[i]}$TERM_RESET"
				done
				return 0
			else
				mapfile TEXT
				for ((i=0; i<${#TEXT[@]}; i++)); do
					echo -n "$($LOG_PROMPT_FUNC)${TEXT[i]}$TERM_RESET" # -n weil \n schon in text!
				done
				return 0
			fi
		# use positional parameters as log messages
		else 
			if [ "$1" -ge 0 -a "$1" -lt $TERM_COLORS ]; then
				temp="$1"
				shift 1
				echo "$($LOG_PROMPT_FUNC)${TERM_COLORS_VALUES[$temp]}${@}$TERM_RESET"
				return 0
			else
				echo "$($LOG_PROMPT_FUNC)${@}"
				return 1
			fi
		fi
	else
		shift 1
		blog $@
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
flog(){
	if [ $# = 0 ] || ! is_int "$1"; then
		echo You have to provide a color code
		return 1
	fi
	
	local color="${TERM_COLORS_VALUES[$1]}"
	local format=""
	local count=0

	# check color code
	if [ "$1" -ge 0 -a "$1" -lt $TERM_COLORS ]; then
		shift 1
	else
		color=""
		shift 1
		# error no color output
	fi

	if [ "$#" -gt 0 ]; then
		# parse format codes, no error detection 
		for i in $@; do
			case "$i" in
				(bold) 
					format=${format}$TERM_BOLD ;;
				(blink) 
					format=${format}$TERM_BLINK ;;
				(under) 
					format=${format}$TERM_UNDERLINE ;;
				(dim) 
					format=${format}$TERM_DIM ;;
				(neg) 
					format=${format}$TERM_NEGATIVE ;;
				(*) 	
					break ;;
			esac
			((count++))
		done
		shift $count
	fi
	
	# only color sequences if stdin outputs to a terminal
	if [ -t 1 ]; then 
		if [ "$#" = 0 ]; then
			# take arguments from stdin
			mapfile TEXT
			for ((i=0; i<${#TEXT[@]}; i++)); do
				echo -n "$($LOG_PROMPT_FUNC)${color}${format}${TEXT[i]}$TERM_RESET"
			done
			return 0
		elif [ "$#" -gt 0 ]; then
			# take arguments from $3 - $#
			echo "$($LOG_PROMPT_FUNC)${format}${color}${@}$TERM_RESET"
		else
			echo Sie müssen einen Farbcode und einen Formatcode angeben >&2 
			return 1
		fi
	else
		blog $@
	fi
}

qlog(){
:
}
