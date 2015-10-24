##
# Box drawing light (U+2500...)
##
SL_TLC="┌"
SL_BLC="└"
SL_TRC="┐"
SL_BRC="┘"
SL_HL="─"
SL_VL="│"
SL_TL="├" # Tee pieces
SL_TR="┤"
SL_TB="┴"
SL_TT="┬"
SL_CROSS="┼"

##
# Symbols
##
SL_HEART="❤"

##
# This is used for compatibility
##
sl-set-ascii-mode(){
	SL_TLC="+"
	SL_BLC="+"
	SL_TRC="+"
	SL_BRC="+"
	SL_HL="-"
	SL_VL="|"
	SL_TL="|" # Tee pieces
	SL_TR="|"
	SL_TB="+"
	SL_TT="+"
	SL_CROSS="+"

	##
	# Symbols
	##
	SL_HEART="❤"
		
}

if [ "$TERM" = vt100 ]; then
	sl-set-ascii-mode
fi
