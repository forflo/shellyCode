##
# bash
##
alias sl-pro="vim ~/.profile"
alias sl-rld-shlib=". ~/.profile"
alias sl-rld-repos="cd ~/repos/git/shellyRepo/; ./init.sh; cd -"
alias sl-shlib="vim ~/repos/git/shellyCode/bashcode/functions"
alias sl-admin="vim $HOME/repos/git/admintools"
alias sl-vimrc="vim ~/.vimrc"
alias sl-al="vim ~/repos/git/shellyCode/bashcode/functions/aliasses.sh"
alias sl-repconf="vim ~/repos/git/shellyRepo/shellyRepoConf.sh"

##
# Window configuration
##
alias sl-ezs="xrandr --output LVDS-1 --mode 1440x900 \
    --pos 0x0 --rotate normal --output DP-3 \
    --off --output DP-2 --off --output DP-1 \
    --off --output VGA-1 --mode 1280x960 \
    --pos 1440x0 --rotate normal"

alias sl-nor="xrandr --output LVDS-1 --mode 1440x900 \
    --pos 0x0 --rotate normal --output DP-3 \
    --off --output DP-2 --off --output DP-1 \
    --off --output VGA-1 --off"

alias sl-eizo="xrandr --output LVDS-1 --mode 1440x900 \
    --pos 1080x0 --rotate normal --output DP-3 \
    --off --output DP-2 --off --output DP-1 \
    --off --output VGA-1 --mode 1920x1080 --pos 0x0 --rotate left"

alias sl-hom="xrandr --output LVDS-1 --mode 1440x900 \
    --pos 0x1080 --rotate normal --output DP-3 \
    --off --output DP-2 --off --output DP-1 \
    --mode 1920x1080 --pos 0x0 --rotate normal \
    --output VGA-1 --off"

alias sl-homd="xrandr --output LVDS-1 --off \
    --output DP-3 --off --output DP-2 --off \
    --output VGA-1 \
    --mode 1920x1080 --pos 0x0 --rotate normal\
    --output DP-1 --mode 1920x1080 \
    --pos 1920x0 --rotate normal"

##
# ls
##
sl-onos-exec linux 'alias "ls"="ls --color=auto"' darwin 'alias "ls"="ls -G"'
alias "ll"="ls -la"
alias "bc"="bc -l"

##
# MacPorts
##
sl-onos-ret darwin && {
	alias "pfind"="port search"
	alias "pinst"="sudo port install"
	alias "pupt"="sudo port selfupdate"
}

##
# Programming stuff
##
alias sl-to="xfce4-terminal --command=\"bash -l\""
alias prepl="perl -d -e 1"
alias hasquefique="ghci"
alias copy-pkgconfig="cp /usr/share/pacman/PKGCONFIG.sample"
alias luarocks-upload="luarocks upload --api-key=\"mHcERL228mI5ujYP288RPT5F1yG75Z4686WPtX9D\" "
alias octave="octave --no-gui -q"
alias master="cdstud; cd MA/vhdlpp_parser/vhdlpp; sl-to; ranger"
alias comp="cd ~/ownCloud/computing/research/"
alias cli="/home/florian/ownCloud/documents/Stud_MasterInf/4-SS2016/MA/cling/cling_ubuntu14/bin/./cling"

# starts make clean; CUSTOM="-fdiagnostics-color=always" make |& less -R
# in separate terminal window with adjustet geometry for better debugging
alias merr='xfce4-terminal --geometry=120x67 \
    --command="bash -c \"make clean; \
    CUSTOM=\"-fdiagnostics-color=always\" make |& less -R\""'

##
# Sed & grep
##
alias sgrep="grep --color"
alias grep="grep -E --color"

##
# Locations 
##
alias "sl-thu"="(nohup bash -c 'thunar . & exit 0' >/dev/null 2>&1)"
alias "cdstud"="cd /home/florian/ownCloud/documents/Stud_MasterInf/4-SS2016"
alias "cdwork"="cd /home/florian/ownCloud/work/Florian\\ Mayer/"
alias "cdback"="cd $OLDPWD"
alias "cdenv"="cd $HOME/environment"
alias "cdetc"="cd /etc"
alias "cdclib"="cdenv; cd code/c/clib"
alias "cdmach7"="cd /home/florian/repos/git/Mach7/"
alias "cdmaster"="cdstud; cd MA/vhdlpp_parser/vhdlpp"
alias "cdctools"="cdenv; cd code/c/tools"
alias cdd="$(sl-onos darwin 'cd ~/Desktop' cygwin "")"

sl-onos-ret darwin && {
	alias "cdScreenshots"="cd /Users/florianmayer/Pictures/Screenshots"
	alias "openScreenshots"="open /Users/florianmayer/Pictures/Screenshots"
	alias "cdstud"="cd /Users/florian/Documents/FhRosenheimLernstoff/Material/"
	alias "cdba"="cd /Users/florian/Documents/FhRosenheimLernstoff/Material/7-WS2013/Bachelorarbeit"
}

alias 2up="cd ../.."
alias 3up="cd ../../.."
alias 4up="cd ../../../.."
alias 5up="cd ../../../../.."

alias "connectLegup"="ssh legup@192.168.2.104"
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
sl-onos-exec linux 'alias asc="osascript"'
