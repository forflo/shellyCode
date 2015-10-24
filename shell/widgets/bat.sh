#Autor: Florian Mayer
#Datum: 10.Sept.2013
#Battery Power Widget for the widget library
##

declare -Ag SL_WSTATUS_BAT

SL_WSTATUS_BAT=(
	["index"]=1	
	["enable"]=true
	["foreground"]=""
	["background"]=""
	["data"]=""
	["oldval"]=""
    ["alwayson"]="true"
    ["delimiter"]="[]"
)

## 
# returns 0 if something has changed
# and 1 if not
sl-notify-bat(){
	[ "${SL_WSTATUS_BAT[oldval]}" != "${SL_WSTATUS_BAT[data]}" ] && {
		SL_WSTATUS_BAT["oldval"]=${SL_WSTATUS_BAT["data"]}		
		return 0
	} || return 1
}

##
# sets the string for this widget
sl-setdata-bat(){
    local percent=$(sl-lp-battery)
    local ret=$?

    [ $ret = 4 ] && {
	    SL_WSTATUS_BAT["enable"]=false
    }

    [ $ret = 3 ] && {
        SL_WSTATUS_BAT["enable"]=true
        SL_WSTATUS_BAT["data"]="$SL_CHARGING${percent}%"
        SL_WSTATUS_BAT["foreground"]=$SL_FG_GREEN
    }

    [ $ret = 2 ] && {
        SL_WSTATUS_BAT["enable"]=true
        SL_WSTATUS_BAT["data"]="$SL_CHARGING${percent}%"
        SL_WSTATUS_BAT["foreground"]=$SL_FG_YELLOW
    }

    [ $ret = 1 ] && {
        SL_WSTATUS_BAT["enable"]=true
        SL_WSTATUS_BAT["data"]="$SL_DISCHARGING${percent}%"
        SL_WSTATUS_BAT["foreground"]=$SL_FG_GREEN
    }

    [ $ret = 0 ] && {
        SL_WSTATUS_BAT["enable"]=true
        SL_WSTATUS_BAT["data"]="$SL_DISCHARGING${percent}%"
        SL_WSTATUS_BAT["foreground"]=$SL_FG_YELLOW
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
            if [[ ${bat} -le $LP_BATTERY_THRESHOLD ]] ; then
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
            if [[ ${bat} -le $LP_BATTERY_THRESHOLD ]] ; then
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
        [[ "$LP_ENABLE_BATT" != 1 ]] && return 4
        local pmset="$(pmset -g batt | sed -n -e '/InternalBattery/p')"
        local bat="$(cut -f2 <<<"$pmset")"
        bat="${bat%%%*}"
        case "$pmset" in
            *charged* | "")
            return 4
            ;;
            *discharging*)
            if [[ ${bat} -le $LP_BATTERY_THRESHOLD ]] ; then
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
            if [[ ${bat} -le $LP_BATTERY_THRESHOLD ]] ; then
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
