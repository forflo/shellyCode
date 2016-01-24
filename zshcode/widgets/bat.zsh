#Autor: Florian Mayer
#Datum: 10.Sept.2013
#Battery Power Widget for the widget library
##

SL_BATTERY_THRESHOLD="60"
declare -Ag SL_WSTATUS_BAT

SL_WSTATUS_BAT=(
	enable "true"
	foreground "$SL_FG_CYAN"
	background ""
    format ""
	data ""
	oldval ""
    triggered "true" # only if sl-notify-bat returned 0
    delimiter "[]"
    del_foreground "$SL_FG_GREEN"
    del_background ""
    trigger "false" # set to true if data and oldval changed
    del_format ""
)

## 
# returns 0 if something has changed
# and 1 if not
sl-notify-bat(){
	[ "${SL_WSTATUS_BAT[oldval]}" != "${SL_WSTATUS_BAT[data]}" ] && {
		SL_WSTATUS_BAT[oldval]=${SL_WSTATUS_BAT[data]}		
		SL_WSTATUS_BAT[trigger]="true"
	} || SL_WSTATUS_BAT[trigger]="false"
}

##
# sets the string for this widget
sl-setdata-bat(){
    sl-lp-battery > /dev/null
    local ret=$?
    local percent=$(sl-lp-battery)

    [ $ret = 4 ] && {
	    SL_WSTATUS_BAT[enable]=false
    }

    [ $ret = 3 ] && {
        SL_WSTATUS_BAT[enable]=true
        SL_WSTATUS_BAT[data]="$SL_CHARGING${percent}%"
        SL_WSTATUS_BAT[foreground]=$SL_FG_GREEN
    }

    [ $ret = 2 ] && {
        SL_WSTATUS_BAT[enable]=true
        SL_WSTATUS_BAT[data]="$SL_CHARGING${percent}%"
        SL_WSTATUS_BAT[foreground]=$SL_FG_RED
    }

    [ $ret = 1 ] && {
        SL_WSTATUS_BAT[enable]=true
        SL_WSTATUS_BAT[data]="$SL_DISCHARGING${percent}%"
        SL_WSTATUS_BAT[foreground]=$SL_FG_GREEN
    }

    [ $ret = 0 ] && {
        SL_WSTATUS_BAT[enable]=true
        SL_WSTATUS_BAT[data]="$SL_DISCHARGING${percent}%"
        SL_WSTATUS_BAT[foreground]=$SL_FG_RED
    }

	return 0
}

##
# From: https://github.com/nojhan/liquidprompt 
##
# Get the battery status in percent
# returns 0 (and battery level) if battery is discharging and under threshold
# returns 1 (and battery level) if battery is discharging and above threshold
# returns 2 (and battery level) if battery is charging but under threshold
# returns 3 (and battery level) if battery is charging and above threshold
# returns 4 if no battery support
# creates the sl-lp-battery function
##
sl-onos-ret linux && {
    sl-lp-battery() {
        local acpi
        acpi="$(acpi --battery 2>/dev/null)"
        # Extract the battery load value in percent
        # First, remove the beginning of the line...
        local bat="${acpi#Battery *, }"
        bat="${bat%%%*}" # remove everything starting at '%'

        if [[ -z "${bat}" ]] ; then
            # not battery level found
            return 4

        # discharging
        elif [[ "$acpi" == *"Discharging"* ]] ; then
            if [[ ${bat} -le $SL_BATTERY_THRESHOLD ]] ; then
                # under threshold
                echo -n "${bat}"
                return 0
            else
                # above threshold
                echo -n "${bat}"
                return 1
            fi

        # charging
        else
            if [[ ${bat} -le $SL_BATTERY_THRESHOLD ]] ; then
                # under threshold
                echo -n "${bat}"
                return 2
            else
                # above threshold
                echo -n "${bat}"
                return 3
            fi
        fi
    }
}

sl-onos-ret darwin && {
    sl-lp-battery() {
        local pmset="$(pmset -g batt | sed -n -e '/InternalBattery/p')"
        local bat="$(cut -f2 <<<"$pmset")"
        bat="${bat%%%*}"
        case "$pmset" in
            *charged* | "")
            return 4
            ;;
            *discharging*)
            if [[ ${bat} -le $SL_BATTERY_THRESHOLD ]] ; then
                # under threshold
                echo -n "${bat}"
                return 0
            else
                # above threshold
                echo -n "${bat}"
                return 1
            fi
            ;;
            *)
            if [[ ${bat} -le $SL_BATTERY_THRESHOLD ]] ; then
                # under threshold
                echo -n "${bat}"
                return 2
            else
                # above threshold
                echo -n "${bat}"
                return 3
            fi
            ;;
        esac
    }
}
