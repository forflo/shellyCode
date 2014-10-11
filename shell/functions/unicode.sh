##
# Box drawing light (U+2500...)
##
TLC="┌"
BLC="└"
TRC="┐"
BRC="┘"
HL="─"
VL="│"
TL="├" # Tee pieces
TR="┤"
TB="┴"
TT="┬"
CROSS="┼"

##
# Symbols
##
HEART="❤"

##
# This is used for compatibility
##
set_ascii_mode(){
	TLC="+"
	BLC="+"
	TRC="+"
	BRC="+"
	HL="-"
	VL="|"
	TL="|" # Tee pieces
	TR="|"
	TB="+"
	TT="+"
	CROSS="+"

	##
	# Symbols
	##
	HEART="❤"
		
}

if [ "$TERM" = vt100 ]; then
	set_ascii_mode
fi
