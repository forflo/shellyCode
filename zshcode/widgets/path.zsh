typeset -Ag SL_WSTATUS_PATH

SP_LP_MARK_SHORTEN_PATH="$SL_CONT"
SP_LP_PATH_LENGTH=17
SL_LP_PATH_KEEP=1

SL_WSTATUS_PATH=(
	enable true # if false it won't be shown
	foreground "$FG_GREEN"
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
sl-notify-path(){
    [ "${SL_WSTATUS_PATH[oldval]}" != "${SL_WSTATUS_PATH[data]}" ] && {
    	SL_WSTATUS_PATH[oldval]=${SL_WSTATUS_PATH[data]}		
        SL_WSTATUS_PATH[trigger]=true
    } || SL_WSTATUS_PATH[trigger]=false
}

##
# sets the string for this widget
sl-setdata-path(){
	SL_WSTATUS_PATH[data]="$(sl-lp-shorten-path)"
	return 0
}

sl-lp-get-home-tilde-collapsed(){
    local tilde="~"
    echo "${PWD/#$HOME/$tilde}"
}

sl-lp-shorten-path(){
    local ret=""

    local p="$(sl-lp-get-home-tilde-collapsed)"
    local mask="${SP_LP_MARK_SHORTEN_PATH}"
    local -i max_len=$(( ${COLUMNS:-80} * SP_LP_PATH_LENGTH / 100 ))

    if [[ ${SL_LP_PATH_KEEP} == -1 ]]; then
        # only show the current directory, excluding any parent dirs
        ret="${p##*/}" # discard everything up to and including the last slash
        [[ "${ret}" == "" ]] && ret="/" # if in root directory
    elif (( ${#p} <= max_len )); then
        ret="${p}"
    elif [[ ${SL_LP_PATH_KEEP} == 0 ]]; then
        # len is over max len, show as much of the tail as is allowed
        ret="${p##*/}" # show at least complete current directory
        p="${p:0:${#p} - ${#ret}}"
        ret="${mask}${p:${#p} - (${max_len} - ${#ret} - ${#mask})}${ret}"
    else
        # len is over max len, show at least SL_LP_PATH_KEEP leading dirs and
        # current directory
        local tmp=${p//\//}
        local -i delims=$(( ${#p} - ${#tmp} ))

        for (( dir=0; dir < SL_LP_PATH_KEEP; dir++ )); do
            (( dir == delims )) && break

            local left="${p#*/}"
            local name="${p:0:${#p} - ${#left}}"
            p="${left}"
            ret="${ret}${name%/}/"
        done

        if (( delims <= SL_LP_PATH_KEEP )); then
            # no dirs between SL_LP_PATH_KEEP leading dirs and current dir
            ret="${ret}${p##*/}"
        else
            local base="${p##*/}"

            p="${p:0:${#p} - ${#base}}"

            [[ ${ret} != "/" ]] && ret="${ret%/}" # strip trailing slash

            local -i len_left=$(( max_len - ${#ret} - ${#base} - ${#mask} ))

            ret="${ret}${mask}${p:${#p} - ${len_left}}${base}"
        fi
    fi
    # Escape special chars
    echo "${ret//\\/\\\\}"
}
