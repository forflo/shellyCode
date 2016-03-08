sl-log-persistent(){
    [[ $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$ ]]
    local date_part="${BASH_REMATCH[1]}"
    local command_part="${BASH_REMATCH[2]}"

    echo $date_part "|" "$command_part" >> ~/.persistent_history
}

alias sl-persistent-grep="cat ~/.persistent_history|grep -E --color"
alias sl-persistent-edit="vim ~/.persistent_history"
