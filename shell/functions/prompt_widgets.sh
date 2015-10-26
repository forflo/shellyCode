SL_DELIMITER="$SL_HL"
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

declare -Ag SL_WIDGETS_STATUS
declare -Ag SL_WIDGETS_NOTIFY
declare -Ag SL_WIDGETS_SETDATA

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

sl-print-notify(){
    for widget in ${!SL_WIDGETS_STATUS[*]}; do
        local widget_arr=${SL_WIDGETS_STATUS[$widget]}
        
        echo $(eval "echo \${${widget_arr}[\"data\"]}") 
        echo $(eval "echo \${${widget_arr}[\"oldval\"]}") 

    done
}

sl-update-widgets(){
    for widget in ${!SL_WIDGETS_STATUS[*]}; do
        local update_func=${SL_WIDGETS_SETDATA[$widget]}
        local notify_func=${SL_WIDGETS_NOTIFY[$widget]}

        ${update_func}
        ${notify_func}
    done

    return 0
}

sl-get-prompt(){
    local begin="$SL_TLC"
    local widgets="$(sl-get-widgets)"
    local end="$SL_BLC"
    
    echo "$begin$widgets\n$end"
}

sl-get-widgets(){
    local widget_result=""
    local widget_data=()
    local widget_enable=()
    local widget_foreground=()
    local widget_background=()
    local widget_delimiter=()
    local widget_triggered=()
    local widget_notify=()
    local widget_del_fg=()
    local widget_del_bg=()
    local widget_del_fmt=()
    local widget_format=()
    local widget_trigger=()
    local count=0

    for widget in ${!SL_WIDGETS_STATUS[*]}; do
        local widget_arr=${SL_WIDGETS_STATUS[$widget]}
        local widget_index=$(eval "echo \${${widget_arr}[\"index\"]}")

        widget_data[widget_index]=$(eval "echo \${${widget_arr}[\"data\"]}") 
        widget_foreground[widget_index]=$(eval "echo \${${widget_arr}[\"foreground\"]}")
        widget_background[widget_index]=$(eval "echo \${${widget_arr}[\"background\"]}")
        widget_enable[widget_index]=$(eval "echo \${${widget_arr}[\"enable\"]}")
        widget_delimiter[widget_index]=$(eval "echo \${${widget_arr}[\"delimiter\"]}")  
        widget_triggered[widget_index]=$(eval "echo \${${widget_arr}[\"triggered\"]}")
        widget_del_fg[widget_index]=$(eval "echo \${${widget_arr}[\"del_foreground\"]}")
        widget_del_bg[widget_index]=$(eval "echo \${${widget_arr}[\"del_background\"]}")
        widget_del_fmt[widget_index]=$(eval "echo \${${widget_arr}[\"del_format\"]}")
        widget_trigger[widget_index]=$(eval "echo \${${widget_arr}[\"trigger\"]}")
        widget_format[widget_index]=$(eval "echo \${${widget_arr}[\"format\"]}")

        ((count++))
    done

    for ((i=0; i<$count; i++)); do
        local d=${widget_data[i]} e=${widget_enable[i]} \
              f=${widget_foreground[i]} b=${widget_background[i]} \
              del=${widget_delimiter[i]} trigger=${widget_trigger[i]} \
              t=${widget_triggered[i]} del_fg=${widget_del_fg[i]} \
              del_bg=${widget_del_bg[i]} del_fmt=${widget_del_fmt[i]} \
              fmt=${widget_format[i]}

        local append="false"
        local del_01="${del:0:1}"
        local del_02="${del:1:1}"

        ##
        # \[ and \] is used to mask the invisible chars as non existent for
        # lib readline. This is necessary, because otherwise readline
        # would incorrectly calculate the line length 
        # echo triggered:$t notify=$n data=$d
        [ "$e" = "true" -a "$t" = "false" ] && append="true"
        [ "$e" = "true" -a "$t" = "true" -a "$trigger" = "true" ] && append="true"

        [ $append = "true" ] && {
            widget_result+="$SL_DELIMITER\[$del_fmt$del_fg$del_bg\]${del_01}\[$SL_TERM_RESET\]"
            widget_result+="\[$f$b$fmt\]$d\[$SL_TERM_RESET\]"
            widget_result+="\[$del_fmt$del_fg$del_bg\]${del_02}\[$SL_TERM_RESET\]"
        }
    done

    echo "$widget_result"
    return 0
}

sl-get-pc(){
    echo 'sl-update-widgets ; PS1=$(sl-get-prompt)'
}

sl-load-widgets
