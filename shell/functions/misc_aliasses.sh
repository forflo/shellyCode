#------------#
# Aliasses   #
#------------#
##
# Truecrypt
##
alias "mntCont1"="TrueCrypt --mount /Volumes/External/Container"
alias "mntCont2"="TrueCrypt --mount /Volumes/External/Container2"
alias "mntCont3"="TrueCrypt --mount /Volumes/External/Container3"
alias "umntAll"="TrueCrypt --dismount"
alias "mntLibry"="TrueCrypt --mount ~/Desktop/LEGACY/cont.tc"
alias "umntExt"="diskutil eject External"

##
# bash
##
alias edit="vim ~/.profile"
alias funcs="declare -F"
alias reload=". ~/.profile"
alias edit_glob="vim $CONFIGDIR/$GLOB_BASHRC"
alias edit_syslink="cdenv ; vim environment/"
alias edit_bashlib="vim ~/environment/code/shell/functions"
alias edit_widget="vim $BASH_LIB/widgets"
alias edit_admin="vim $HOME/repos/git/admintools"
alias edit_vimrc="vim ~/.vimrc"
alias edit_sysconf="vim ~/environment/configuration/mapping"


function env_reinstall(){
	curl -L http://bit.ly/1wg9vdQ | bash || {
		clog 1 "env_reinstall" Reinstalling failed!
		return 1
	}
	
	return 0
}

##
# ls
##
onos_exec linux 'alias "ls"="ls --color=auto"' darwin 'alias "ls"="ls -G"'
alias "ll"="ls -la"
alias "bc"="bc -l"

##
# MacPorts
##
onos_ret darwin && {
	alias "pfind"="port search"
	alias "pinst"="sudo port install"
	alias "pupt"="sudo port selfupdate"
}

##
# python and scripting languages
##
alias prepl="perl -d -e 1"

##
# GNU Screen
##
# -U: UTF-8 modus
alias screen="screen -U -S \$(date \"+%d.%m.%y-%H:%M\")"

##
# Sed & grep
##
alias sgrep="grep --color"
alias grep="grep -E --color"

##
# cd 
##
alias "cdback"="cd $OLDPWD"
alias "cdstud"="cd /Users/florian/Documents/FhRosenheimLernstoff/Material/"
alias "cdba"="cd /Users/florian/Documents/FhRosenheimLernstoff/Material/7-WS2013/Bachelorarbeit"
alias "cdenv"="cd $HOME/environment"
alias "cdetc"="cd /etc"
alias "cdclib"="cdenv; cd code/c/clib"
alias "cdctools"="cdenv; cd code/c/tools"
#alias cdd="$(onos cygwin "cd /cygdrive/c/Users/$(whoami)/Desktop" linux 'cd ~/Desktop' darwin 'cd ~/Desktop')"
alias cdd="$(onos darwin 'cd ~/Desktop' cygwin "")"

alias "cdScreenshots"="cd /Users/florianmayer/Pictures/Screenshots"
alias "openScreenshots"="open /Users/florianmayer/Pictures/Screenshots"
alias 2up="cd ../.."
alias 3up="cd ../../.."
alias 4up="cd ../../../.."
alias 5up="cd ../../../../.."

##
# SSH
##
if [ -z "$SSH_AGENT_PID" ]; then #in case of reloading the profile
	eval $(ssh-agent)
fi

alias "connectsrv"="ssh -p 7779 root@192.168.2.119"
alias "connectklingon"="ssh florian@klingon.inf.fh-rosenheim.de"
alias "connecttartaros"="ssh root@tartaros.mooo.com"

##
# System
##
alias "end"="sudo shutdown -h now"
alias "getIP"="ifconfig en0 | head -n 5 | tail -n 1 | cut -c 7-20"
alias "lock"="xscreensaver-command --lock"

#alias "wakeupSrv"="wakeonlan `getMacAddr.sh debianTerminalServer`"
alias "makeExec"="mkExec(){; chmod 750 $1 ;} mkExec"

##
# Work
##
alias cdadmin="cd ~/environment/code/shell/admin_scripts"

alias "mkdircd"="f(){ mkdir -p \"\$1\"; cd \"\$1\"; }; f"
alias "info"="info --vi-keys"

alias gnulib="echo git clone git://git.sv.gnu.org/gnulib.git"
alias asc="osascript"
