SL_DELIMITER=""
SL_WIDGETCONF=~/repos/git/shellyCode/bashcode/widgets/wconf.sh
SL_WIDGET_DIR=~/repos/git/shellyCode/bashcode/widgets
#EDIT 13.Dez.2013
#Widget should not be seen if no useful information is available
#This behaviour is changeable
##

sl-load-widgets(){
    . $SL_WIDGETCONF

	for i in ${!SL_WIDGETS_STATUS[*]}; do
		echo Loading Widget $i
		. ${SL_WIDGET_DIR}/${i}
	done

	return 0
}

sl-print-notify(){
    for widget in ${!SL_WIDGETS_STATUS[*]}; do
        local widget_arr=${SL_WIDGETS_STATUS[$widget]}
        
        eval echo "\${${widget_arr}[\"data\"]}"
        eval echo "\${${widget_arr}[\"oldval\"]}"

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
    local end="$SL_BLC$SL_HL["
    
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
    local index=0

    for widget in ${!SL_WIDGETS_STATUS[*]}; do
        local widget_arr=${SL_WIDGETS_STATUS[$widget]}

        eval widget_data[index]="\${${widget_arr}[\"data\"]}"
        eval widget_foreground[index]="\${${widget_arr}[\"foreground\"]}"
        eval widget_background[index]="\${${widget_arr}[\"background\"]}"
        eval widget_enable[index]="\${${widget_arr}[\"enable\"]}"
        eval widget_delimiter[index]="\${${widget_arr}[\"delimiter\"]}"
        eval widget_triggered[index]="\${${widget_arr}[\"triggered\"]}"
        eval widget_del_fg[index]="\${${widget_arr}[\"del_foreground\"]}"
        eval widget_del_bg[index]="\${${widget_arr}[\"del_background\"]}"
        eval widget_del_fmt[index]="\${${widget_arr}[\"del_format\"]}"
        eval widget_trigger[index]="\${${widget_arr}[\"trigger\"]}"
        eval widget_format[index]="\${${widget_arr}[\"format\"]}"

        ((index++))
    done

    for ((i=0; i<$index; i++)); do
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
