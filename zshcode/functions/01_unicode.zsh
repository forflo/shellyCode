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
SL_CHARGING="⏚"
SL_DISCHARGING="⌁"
SL_GIT="±"
SL_MERC="☿"
SL_SVN="‡"
SL_FOSSIL="⌘"
SL_MICRO="µ"
SL_CONT="…"

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
    SL_POWER01="p"
    SL_POWER02="p"

	##
	# Symbols
	##
	SL_HEART="❤"
		
}

if [ "$TERM" = vt100 ]; then
	sl-set-ascii-mode
fi
