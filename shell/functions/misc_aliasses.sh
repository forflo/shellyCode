##
# bash
##
alias edit="vim ~/.profile"
alias funcs="declare -F"
alias rld-shlib=". ~/.profile"
alias rld-repos="cd ~/repos/git/shellyRepo/; ./init.sh; cd -"
alias ed-shlib="vim ~/repos/git/shellyCode/shell/functions"
alias ed-admin="vim $HOME/repos/git/admintools"
alias ed-vimrc="vim ~/.vimrc"
alias ed-al="vim ~/repos/git/shellyCode/shell/functions/misc_aliasses.sh"
alias ed-repconf="vim ~/repos/git/shellyRepo/shellyRepoConf.sh"

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
# Programming stuff
##
alias prepl="perl -d -e 1"
alias le-hasquel="ghci"
alias hasquefique="ghci"
alias hassgefick="ghci"
alias copy-pkgconfig="cp /usr/share/pacman/PKGCONFIG.sample"
alias luarocks-upload="luarocks upload --api-key=\"mHcERL228mI5ujYP288RPT5F1yG75Z4686WPtX9D\" "
alias t="todo.sh"

##
# Sed & grep
##
alias sgrep="grep --color"
alias grep="grep -E --color"

##
# Locations 
##
alias "cdback"="cd $OLDPWD"
alias "cdenv"="cd $HOME/environment"
alias "cdetc"="cd /etc"
alias "cdclib"="cdenv; cd code/c/clib"
alias "cdctools"="cdenv; cd code/c/tools"
#alias cdd="$(onos cygwin "cd /cygdrive/c/Users/$(whoami)/Desktop" linux 'cd ~/Desktop' darwin 'cd ~/Desktop')"
alias cdd="$(onos darwin 'cd ~/Desktop' cygwin "")"

onos_ret darwin && {
	alias "cdScreenshots"="cd /Users/florianmayer/Pictures/Screenshots"
	alias "openScreenshots"="open /Users/florianmayer/Pictures/Screenshots"
	alias "cdstud"="cd /Users/florian/Documents/FhRosenheimLernstoff/Material/"
	alias "cdba"="cd /Users/florian/Documents/FhRosenheimLernstoff/Material/7-WS2013/Bachelorarbeit"
}

alias 2up="cd ../.."
alias 3up="cd ../../.."
alias 4up="cd ../../../.."
alias 5up="cd ../../../../.."

alias "connectsrv"="ssh -p 7779 root@192.168.2.119"
alias "connectklingon"="ssh florian@klingon.inf.fh-rosenheim.de"
alias "connecttartaros"="ssh root@5.45.111.42"

##
# System
##
alias "end"="sudo shutdown -h now"
alias "getIP"="ifconfig en0 | head -n 5 | tail -n 1 | cut -c 7-20"

alias "mkdircd"="urRx(){ mkdir -p \"\$1\"; cd \"\$1\"; }; urRx; unset urRx"
alias "info"="info --vi-keys"

alias gnulib="echo git clone git://git.sv.gnu.org/gnulib.git"
onos_exec linux 'alias asc="osascript"'
