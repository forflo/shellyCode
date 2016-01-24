declare -Ag SL_WIDGETS_STATUS
declare -Ag SL_WIDGETS_NOTIFY
declare -Ag SL_WIDGETS_SETDATA

# Name of widget => Name of widgets status array
SL_WIDGETS_STATUS=(
	["date.sh"]="SL_WSTATUS_DATE"
	#["git.sh"]="SL_WSTATUS_GIT"
	["bat.sh"]="SL_WSTATUS_BAT"
    ["path.sh"]="SL_WSTATUS_PATH"
    ["session.sh"]="SL_WSTATUS_SESS"
)

SL_WIDGETS_NOTIFY=(
	["date.sh"]="sl-notify-date"
	#["git.sh"]="sl-notify-git"
	["bat.sh"]="sl-notify-bat"
    ["path.sh"]="sl-notify-path"
    ["session.sh"]="sl-notify-sess"
)

SL_WIDGETS_SETDATA=(
	["date.sh"]="sl-setdata-date"
	#["git.sh"]="sl-setdata-git"
	["bat.sh"]="sl-setdata-bat"
    ["path.sh"]="sl-setdata-path"
    ["session.sh"]="sl-setdata-sess"
)
