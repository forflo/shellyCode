SL_DELIMITER=""
SL_WIDGETCONF=~/repos/git/shellyCode/zshcode/widgets/wconf.zsh
SL_WIDGET_DIR=~/repos/git/shellyCode/zshcode/widgets
#EDIT 13.Dez.2013
#Widget should not be seen if no useful information is available
#This behaviour is changeable
##

sl-load-widgets(){
    . $SL_WIDGETCONF

	for i in ${(k)SL_WIDGETS_STATUS}; do
		echo Loading Widget $i
		. ${SL_WIDGET_DIR}/${i}
	done

	return 0
}

sl-print-notify(){
    for widget in ${(k)SL_WIDGETS_STATUS}; do
        local widget_arr=${SL_WIDGETS_STATUS[$widget]}
        
        echo $(eval "echo \${${widget_arr}[data]}") 
        echo $(eval "echo \${${widget_arr}[oldval]}") 

    done
}

sl-update-widgets(){
    for widget in ${(k)SL_WIDGETS_STATUS[*]}; do
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
    local end="$SL_BLC$SL_HL""["
    
    echo "$begin$widgets\n$end"
}

sl-print-widget-status(){
    local index=1

    for widget in ${(k)SL_WIDGETS_STATUS[*]}; do
        local widget_arr=${SL_WIDGETS_STATUS[$widget]}
        echo $widget_arr:

        echo data: $(eval "echo \${${widget_arr}[data]}") 
        echo foreground: $(eval "echo \${${widget_arr}[foreground]}") $SL_TERM_RESET
        echo background: $(eval "echo \${${widget_arr}[background]}") $SL_TERM_RESET
        echo enable: $(eval "echo \${${widget_arr}[enable]}")
        echo delimiter: $(eval "echo \${${widget_arr}[delimiter]}")  
        echo triggered: $(eval "echo \${${widget_arr}[triggered]}")
        echo del_foreground: $(eval "echo \${${widget_arr}[del_foreground]}") $SL_TERM_RESET
        echo del_background: $(eval "echo \${${widget_arr}[del_background]}") $SL_TERM_RESET
        echo del_format: $(eval "echo \${${widget_arr}[del_format]}") $SL_TERM_RESET
        echo trigger: $(eval "echo \${${widget_arr}[trigger]}")
        echo format: $(eval "echo \${${widget_arr}[format]}") $SL_TERM_RESET

        ((index++))
    done

    return
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
    local index=1

    for widget in ${(k)SL_WIDGETS_STATUS[*]}; do
        local widget_arr=${SL_WIDGETS_STATUS[$widget]}

        widget_data[index]=$(eval "echo \${${widget_arr}[data]}") 
        widget_foreground[index]=$(eval "echo \${${widget_arr}[foreground]}")
        widget_background[index]=$(eval "echo \${${widget_arr}[background]}")
        widget_enable[index]=$(eval "echo \${${widget_arr}[enable]}")
        widget_delimiter[index]=$(eval "echo \${${widget_arr}[delimiter]}")  
        widget_triggered[index]=$(eval "echo \${${widget_arr}[triggered]}")
        widget_del_fg[index]=$(eval "echo \${${widget_arr}[del_foreground]}")
        widget_del_bg[index]=$(eval "echo \${${widget_arr}[del_background]}")
        widget_del_fmt[index]=$(eval "echo \${${widget_arr}[del_format]}")
        widget_trigger[index]=$(eval "echo \${${widget_arr}[trigger]}")
        widget_format[index]=$(eval "echo \${${widget_arr}[format]}")

        ((index++))
    done

    for ((i=1; i<=$index; i++)); do
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
