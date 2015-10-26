#Autor: Florian Mayer
#Datum: 10.Sept.2013
#Date widget for the widget library
###

declare -Ag SL_WSTATUS_DATE

SL_WSTATUS_DATE=(
	["index"]="0"
	["enable"]=true
	["foreground"]=$SL_TERM_WHITE
	["background"]=""
    ["format"]="$SL_TERM_BOLD"
	["data"]=""
	["oldval"]=""
    ["triggered"]="true" # only show if sl-notify-date returned 0
    ["delimiter"]="{}"
    ["del_background"]=""
    ["del_foreground"]=""
    ["del_format"]=""
    ["trigger"]="false"
)

## 
# returns 0 if something has changed
# and 1 if not
sl-notify-date(){
    [ "${SL_WSTATUS_DATE["oldval"]}" != "${SL_WSTATUS_DATE["data"]}" ] && {
    	SL_WSTATUS_DATE["oldval"]=${SL_WSTATUS_DATE["data"]}		
        SL_WSTATUS_DATE["trigger"]=true
    } || SL_WSTATUS_DATE["trigger"]=false

    return 0
}

##
# sets the string for this widget
sl-setdata-date(){
	SL_WSTATUS_DATE["data"]=$(date "+%d.%m.%y-%H:%M")

	return 0
}
