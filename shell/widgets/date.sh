#Autor: Florian Mayer
#Datum: 10.Sept.2013
#Date widget for the widget library
###

declare -Ag SL_WSTATUS_DATE

SL_WSTATUS_DATE=(
	["index"]="0"
	["enable"]=true
	["foreground"]=$FG_GREEN
	["background"]=""
	["data"]=""
	["oldval"]=""
)

## 
# returns 0 if something has changed
# and 1 if not
sl-notify-date(){
	[ "${SL_WSTATUS_DATE[oldval]}" != "${SL_WSTATUS_DATE[data]}" ] && {
		SL_WSTATUS_DATE["oldval"]=${SL_WSTATUS_DATE["data"]}		
		return 0
	} || return 1
}

##
# sets the string for this widget
sl-setdata-date(){
	SL_WSTATUS_DATE["data"]=$(date "+%d.%m.%y-%H:%M")

	return 0
}
