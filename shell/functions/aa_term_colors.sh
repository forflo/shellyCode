##
# Generic Colors should be available almost everywhere
##
#Foreground
export FG_BLACK=$(tput setaf 0)
export FG_RED=$(tput setaf 1)
export FG_GREEN=$(tput setaf 2)
export FG_YELLOW=$(tput setaf 3)
export FG_BLUE=$(tput setaf 4)
export FG_PURPLE=$(tput setaf 5)
export FG_CYAN=$(tput setaf 6)
export FG_WHITE=$(tput setaf 7)
export FG_ARR=(FG_BLACK FG_RED FG_GREEN FG_YELLOW FG_BLUE FG_PURPLE FG_CYAN FG_WHITE)

#Background
export BG_BLACK=$(tput setab 0)
export BG_RED=$(tput setab 1)
export BG_GREEN=$(tput setab 2)
export BG_YELLOW=$(tput setab 3)
export BG_BLUE=$(tput setab 4)
export BG_PURPLE=$(tput setab 5)
export BG_CYAN=$(tput setab 6)
export BG_WHITE=$(tput setab 7)
export BG_ARR=(BG_BLACK BG_RED BG_GREEN BG_YELLOW BG_BLUE BG_PURPLE BG_CYAN BG_WHITE)

#Extended Color-Values
export TERM_COLORS=$(tput colors)
export TERM_COLORS_VALUES=
for ((i=0; i<$TERM_COLORS; i++)); do
	TERM_COLORS_VALUES[i]="$(tput setaf $i)" # innerhalb von [] müssen variablen nicth
						 # mit $ gekennzeichnet werden, da es sich
						 # hier um einen arithmetischen ausdruck handelt!
done

#Formatting
export TERM_BOLD=$(tput bold)
export TERM_DIM=$(tput dim)
export TERM_UNDERLINE=$(tput smul)
export TERM_NEGATIVE=$(tput setab 7)
export TERM_BLINK=$(tput blink)

#Special Functions
export TERM_RESET=$(tput sgr0)

##
# Functions
##
random_color(){
	colorname=${FG_ARR[$(random_simple 8)]}
	echo -n ${!colorname}
}

random_color_extended(){
	echo -n "${TERM_COLORS_VALUES[$(random_simple 255)]}"
}

term_reset(){
	echo -n $TERM_RESET
}

print_blue(){
	echo -ne $FG_BLUE "$1" $TERM_RESET 
}

print_red(){
	echo -ne $FG_RED "$1" $TERM_RESET 
}

print_black(){
	echo -ne $FG_BLACK "$1" $TERM_RESET 
}

print_green(){
	echo -ne $FG_GREEN "$1" $TERM_RESET 
}

print_yellow(){
	echo -ne $FG_YELLOW "$1" $TERM_RESET 
}

print_purple(){
	echo -ne $FG_PURPLE "$1" $TERM_RESET 
}

print_cyan(){
	echo -ne $FG_CYAN "$1" $TERM_RESET 
}

print_white(){
	echo -ne $FG_WHITE "$1" $TERM_RESET 
}
