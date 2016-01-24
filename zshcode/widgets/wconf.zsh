typeset -Ag SL_WIDGETS_STATUS
typeset -Ag SL_WIDGETS_NOTIFY
typeset -Ag SL_WIDGETS_SETDATA

# Name of widget => Name of widgets status array
SL_WIDGETS_STATUS=(
	"date.zsh" "SL_WSTATUS_DATE"
	"bat.zsh" "SL_WSTATUS_BAT"
    "path.zsh" "SL_WSTATUS_PATH"
    "session.zsh" "SL_WSTATUS_SESS"
)

SL_WIDGETS_NOTIFY=(
	"date.zsh" "sl-notify-date"
	"bat.zsh" "sl-notify-bat"
    "path.zsh" "sl-notify-path"
    "session.zsh" "sl-notify-sess"
)

SL_WIDGETS_SETDATA=(
	"date.zsh" "sl-setdata-date"
	"bat.zsh" "sl-setdata-bat"
    "path.zsh" "sl-setdata-path"
    "session.zsh" "sl-setdata-sess"
)
