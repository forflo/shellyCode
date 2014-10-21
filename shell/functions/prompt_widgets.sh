DELIMITER="|"
WIDGET_DIR="~/repos/git/shellyCode/shell/widgets/"
P_NULL="yes"
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
LINE_BREAK="auto" # specifies the number of widgets a linefeed should follow

for i in $WIDGET_DIR/p_widget_*; do
	echo Loading widget $i ...
	. "$i"
	eval $(basename $i)
done

get_prompt_additions(){
	cd $WIDGET_DIR ; local result="$DELIMITER" ; local count=0 ; local current_space=2
	for i in p_widget_*; do
		local temp=$(upper $i)_ENABLE
		local temp2=$(upper $i)_DATA
		if [ "${!temp}" = true -a -n "${temp2}" ]; then
			if [ "$LINE_BREAK" != auto ]; then
				if [ $((count++%LINE_BREAK)) = 0 ]; then
					result="$result""\n$TL$HL"
				fi
				result="$result"'\[${'$(upper $i)_FG'}\]\[${'$(upper $i)_BG'}\]\[${'$(upper $i)_DATA'}\]\['${TERM_RESET}'\]'"$DELIMITER"
			else
				if [ $count -eq 0 ]; then
					result="$result""\n$TL$HL"
					((count++))
				fi
				#local space=$COLUMNS
				local space=$(tput cols)
				local t=$(echo -n "${!temp2}" | wc -c)
				((current_space+=t+1))
				if [ $current_space -gt $space ]; then
					((current_space=t+2))
					result="$result""\n$TL$HL"
				fi
				result="$result"'\[${'$(upper $i)_FG'}\]\[${'$(upper $i)_BG'}\]\[${'$(upper $i)_DATA'}\]\['${TERM_RESET}'\]'"$DELIMITER"
			fi
		fi
	done
	echo "$result""\n$BLC$HL$HL" ; cd $OLDPWD
}

get_prompt_commands(){
	cd $WIDGET_DIR ;local result=
	for i in *; do
		result="$result""$i"' ; '
	done
	echo "$result"
	cd $OLDPWD
}

