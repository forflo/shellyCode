#Autor: Florian Mayer
#Datum: 10.Sept.2013
#Date widget for the widget library
###

declare -Ag SL_WSTATUS_DATE

SL_WSTATUS_DATE=(
	["index"]="0"
	["enable"]=true
	["foreground"]=$SL_FG_BLACK
	["background"]="$SL_BG_BLUE"
    ["format"]="$SL_TERM_BOLD"
	["data"]=""
	["oldval"]=""
    ["triggered"]="true" # only show if sl-notify-date returned 0
    ["delimiter"]="{}"
    ["del_background"]="$SL_BG_YELLOW"
    ["del_foreground"]="$SL_FG_BLUE"
    ["del_format"]="$SL_TERM_UNDERLINE"
)

## 
# returns 0 if something has changed
# and 1 if not
sl-notify-date(){
    [ "${SL_WSTATUS_DATE["oldval"]}" != "${SL_WSTATUS_DATE["data"]}" ] && {
    	echo data:${SL_WSTATUS_DATE["data"]}		
    	echo oldval:${SL_WSTATUS_DATE["oldval"]}
    	SL_WSTATUS_DATE["oldval"]=${SL_WSTATUS_DATE["data"]}		
        
        SL_WSTATUS_DATE["oldval"]=${SL_WSTATUS_DATE["data"]}
         echo data:0
    	return 0
    } || return 1
}

##
# sets the string for this widget
sl-setdata-date(){
	SL_WSTATUS_DATE["data"]=$(date "+%d.%m.%y-%H:%M")

	return 0
}
