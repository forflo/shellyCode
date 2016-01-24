declare -Ag SL_WSTATUS_DATE

SL_WSTATUS_DATE=(
	enable true # if false it won't be shown
	foreground $FG_GREEN
	background ""
    format "" # Format (like blink or underline)
	data "" # string to show
	oldval "" #internal purpose
    triggered "true" # only show if sl-notify-date returned 0
    delimiter "<>" # ["data"] will be surrounded by these two
    del_foreground "" # color the delimiter should have
    del_background "" # color the delimiter should have
    del_format "" 
    trigger "false" # set to true if data and oldval changed
)

## 
# returns 0 if something has changed
# and 1 if not
sl-notify-date(){
    [ "${SL_WSTATUS_DATE["oldval"]}" != "${SL_WSTATUS_DATE["data"]}" ] && {
    	SL_WSTATUS_DATE["oldval"]=${SL_WSTATUS_DATE["data"]}		
        SL_WSTATUS_DATE["trigger"]=true
    } || SL_WSTATUS_DATE["trigger"]=false
}

##
# sets the string for this widget
sl-setdata-date(){
	SL_WSTATUS_DATE["data"]=""
	return 0
}
