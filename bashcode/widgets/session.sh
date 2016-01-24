# 1) In tmux or screen?? Square-brackets enclosing all
# 2) Current uid (bold yellow if root, light white if normal)
# 3) Green @ if connection has X11 support. Yellow if not
# 4) Current hostname (bold red if over telnet, blue with ssh, white if local)
#
# example: [florian@kurerm]
##

declare -Ag SL_WSTATUS_SESS

SL_WSTATUS_SESS=(
	["enable"]=true # if false it won't be shown
	["foreground"]=$FG_GREEN
	["background"]=""
    ["format"]="" # Format (like blink or underline)
	["data"]="" # string to show
	["oldval"]="" #internal purpose
    ["triggered"]="false" # only show if sl-notify-date returned 0
    ["delimiter"]="[]" # ["data"] will be surrounded by these two
    ["del_foreground"]="" # color the delimiter should have
    ["del_background"]="" # color the delimiter should have
    ["del_format"]="" 
    ["trigger"]="false" # set to true if data and oldval changed
)

## 
# returns 0 if something has changed
# and 1 if not
sl-notify-sess(){
    [ "${SL_WSTATUS_SESS["oldval"]}" != "${SL_WSTATUS_SESS["data"]}" ] && {
    	SL_WSTATUS_SESS["oldval"]=${SL_WSTATUS_SESS["data"]}		
        SL_WSTATUS_SESS["trigger"]=true
    } || SL_WSTATUS_SESS["trigger"]=false
}

##
# sets the string for this widget
sl-setdata-sess(){
    local user=$(whoami)
    local hn=$(hostname)
    local hn_cred=""
    local user_cred=""
    local at_cred=""

    [ $user = "root" ] && user_cred="$SL_TERM_BOLD$SL_TERM_YELLOW" || \
        user_cred="$SL_TERM_WHITE$SL_TERM_DIM"

    case "$(sl-lp-connection)" in
        (telnet) hn_cred="$SL_TERM_BOLD$SL_FG_RED" ;;
        (ssh) hn_cred="$SL_FG_BLUE" ;;
        (local) hn_cred="$SL_FG_WHITE" ;;
        (*) ;;
    esac

    sl-lp-withx11 && at_cred="$SL_FG_GREEN" || at_cred="$SL_FG_YELLOW"

	[ -n "$TMUX" -a "$TERM" = "screen" ] && SL_WSTATUS_SESS["del_foreground"]="$SL_FG_GREEN"
	[ "$TERM" = "screen" -a -z "$TMUX" ] && SL_WSTATUS_SESS["del_foreground"]="$SL_FG_CYAN"
    [ -z "$TMUX" -a "$TERM" != "screen" ] && SL_WSTATUS_SESS["del_foreground"]="$SL_FG_WHITE"

	SL_WSTATUS_SESS["data"]="$user_cred$user$SL_TERM_RESET${at_cred}@$SL_TERM_RESET$hn_cred$hn$SL_TERM_RESET"
    
	return 0
}

sl-lp-withx11(){
    if [[ -n "$DISPLAY" ]]; then 
        return 0
    else
        return 1
    fi
}

sl-lp-connection(){
    if [[ -n "$SSH_CLIENT$SSH2_CLIENT$SSH_TTY" ]] ; then 
        echo ssh
    else 
        # TODO check on *BSD
        local sess_src="$(who am i | sed -n 's/.*(\(.*\))/\1/p')"
        local sess_parent="$(ps -o comm= -p $PPID 2> /dev/null)"
        if [[ -z "$sess_src" || "$sess_src" = ":"* ]] ; then 
            echo local  # Local
        elif [[ "$sess_parent" = "su" || "$sess_parent" = "sudo" ]] ; then 
            echo su   # Remote su/sudo
        else
            echo telnet  # Telnet
        fi
    fi   

    return 0
}
