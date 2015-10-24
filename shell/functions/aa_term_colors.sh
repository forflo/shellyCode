##
# Generic Colors should be available almost everywhere
##
#Foreground
export SL_FG_BLACK=$(tput setaf 0)
export SL_FG_RED=$(tput setaf 1)
export SL_FG_GREEN=$(tput setaf 2)
export SL_FG_YELLOW=$(tput setaf 3)
export SL_FG_BLUE=$(tput setaf 4)
export SL_FG_PURPLE=$(tput setaf 5)
export SL_FG_CYAN=$(tput setaf 6)
export SL_FG_WHITE=$(tput setaf 7)
export SL_FG_ARR=(SL_FG_BLACK SL_FG_RED SL_FG_GREEN SL_FG_YELLOW SL_FG_BLUE \
                SL_FG_PURPLE SL_SLFG_CYAN SL_FG_WHITE)

#Background
export SL_BG_BLACK=$(tput setab 0)
export SL_BG_RED=$(tput setab 1)
export SL_BG_GREEN=$(tput setab 2)
export SL_BG_YELLOW=$(tput setab 3)
export SL_BG_BLUE=$(tput setab 4)
export SL_BG_PURPLE=$(tput setab 5)
export SL_BG_CYAN=$(tput setab 6)
export SL_BG_WHITE=$(tput setab 7)
export SL_BG_ARR=(SL_BG_BLACK SL_BG_RED SL_BG_GREEN SL_BG_YELLOW SL_BG_BLUE \
                SL_BG_PURPLE SL_BG_CYAN SL_BG_WHITE)

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
sl-random-color(){
	colorname=${FG_ARR[$(sl-random-simple 8)]}
	echo -n ${!colorname}
}

sl-random-color-extended(){
	echo -n "${TERM_COLORS_VALUES[$(sl-random-simple 255)]}"
}

sl-term_reset(){
	echo -n $TERM_RESET
}
