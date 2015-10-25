#Autor: Florian Mayer
#Datum: 11.Sept.2013
#Git-Widget for the widget library
#Bugs: propably too slow expecially the command git status 
#Change 13.Dez.2013
##

P_WIDGET_02_INDEX=2 
P_WIDGET_02_ENABLE=true
P_WIDGET_02_FG=$FG_YELLOW 
P_WIDGET_02_BG= 
P_WIDGET_02_DATA= # unnötig 
OS=$(uname)

p_widget_02(){
	local last_commit_hash=
	local repo_name=
	local current_branch=
	local last_log_message=
	if git status --short > /dev/null 2>&1 ; then
		repo_name=`basename "$PWD"`
		set `git log -n 1 --pretty=oneline` " " 
		last_commit_hash=${1:0:7}..
		current_branch=`git branch`
		last_log_message="$2 $3 $4 $5 ${6}..."
		P_WIDGET_02_DATA="GIT: $repo_name@${current_branch:2} - ref: ${last_commit_hash} - log: \"${last_log_message:0:20}...\""
		set --
	else 
		if [ "${P_NULL}" = "yes" ]; then
			P_WIDGET_02_DATA=""
		else
			P_WIDGET_02_DATA="currently no repo..."
		fi
	fi
}

