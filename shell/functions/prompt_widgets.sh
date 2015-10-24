SL_DELIMITER=" "
SL_WIDGET_DIR=~/repos/git/shellyCode/shell/widgets
SL_P_NULL="yes"
SL_LINE_BREAK="auto" # specifies the number of widgets a linefeed should follow
##
# LINE_BREAK specifies the number of widgets to show on one line
# This variable can be set to any number greater than zero or
# to the following string value: "auto"
# "auto" means that the line break should be done automatically
# for the user
#
#EDIT 13.Dez.2013
#Widget should not be seen if no useful information is available
#This behaviour is changeable
##

declare -A SL_WIDGETS_STATUS
declare -A SL_WIDGETS_NOTIFY
declare -A SL_WIDGETS_SETDATA

# Name of widget => Name of widgets status array
SL_WIDGETS_STATUS=(
	["date.sh"]="SL_WSTATUS_DATE"
	#["git.sh"]="SL_WSTATUS_GIT"
	["bat.sh"]="SL_WSTATUS_BAT"
)

SL_WIDGETS_NOTIFY=(
	["date.sh"]="sl-notify-date"
	#["git.sh"]="sl-notify-git"
	["bat.sh"]="sl-notify-bat"
)

SL_WIDGETS_SETDATA=(
	["date.sh"]="sl-setdata-date"
	#["git.sh"]="sl-setdata-git"
	["bat.sh"]="sl-setdata-bat"
)

sl-load-widgets(){
	for i in ${!SL_WIDGETS_STATUS[*]}; do
		echo Loading Widget $i
		. ${SL_WIDGET_DIR}/${i}
	done

	return 0
}

sl-get-widgets(){
    local widget_result=""
    local widget_data=()
    local widget_enable=()
    local widget_foreground=()
    local widget_background=()
    local widget_delimiter=()
    local count=0

    for widget in ${!SL_WIDGETS_STATUS[*]}; do
        local status_arr=${SL_WIDGETS_STATUS[widget]}
        widget_index=$(eval "echo \${${status_arr}[\"index\"]}")

        widget_data[widget_index]=$(eval "echo \${${status_arr}[\"data\"]}") 
        widget_foreground[widget_index]=$(eval "echo \${${status_arr}[\"foreground\"]}")
        widget_background[widget_index]=$(eval "echo \${${status_arr}[\"background\"]}")
        widget_enable[widget_index]=$(eval "echo \${${status_arr}[\"enable\"]}")
        widget_delimiter[widget_index]=$(eval "echo \${${status_arr}[\"delimiter\"]}")  
 
        
        widget_notify[widget_index]=$?

        ((count++))
    done

    for ((i=0; i<$count; i++)); do
        local d=${widget_data[i]} e=${widget_enable[i]} \
              f=${widget_foreground[i]} b=${widget_background[i]} 

        
        # \[ and \] is used to mask the invisible chars as non existent for
        # lib readline. This is necessary, because otherwise readline
        # would incorrectly calculate the line length 
        [ "$e" = "true" ] && widget_result+="$SL_DELIMITER\[$f\]\[$b\]\[$d\]\[$TERM_RESET\]"
    done

    echo "$widget_result"
    return 0
}

sl-get-commands(){
	local commands=""

	for i in ${SL_WIDGETS_SETDATA[*]}; do
		commands+="$i ; "	
	done

	echo $commands
	return 0
}
