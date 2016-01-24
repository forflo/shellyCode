#!/bin/bash
################################################################################################################
#Stellt eine Moeglichkeit bereit Fenster mit einem bestimmten Inhalt zu erzeugen
#Jedes Fenster wird wie folgt erstellt
#1 	window 		$1 $2 wobei $1 der Titel und $2 die Farbe ist, mit dem der Titel gezeichnet wird
#2 	append 		$1 $2wobei $1 zentriert in das aktuelle Fenster unter den aktuellen inhalt geschrieben wird
#  			$2 bezeichnet die Farbe, mit der der Text geschrieben wird
#3 	append 		$1 $2 wie #2 nur das $2 zwei optionen enthalten kann. Nämlich "-l" "-r" für links
#  			und rechtsbuendig...
#5 	separate  	trennt das aktuelle Fenster horizontal
#6 	endwin 		schließt das aktuelle Fenster und stellt die erforderlichen Variablen ein 
#7 	newline		setzt die Variablen so, dass das nächste Fenster unter der nächst möglichen
#  			eine Zeile weiter unten gelegenen Fenster links geprintet wird
#################################################################################################################

#################KONVENTIONEN#####################
#
# a)	Variablen werden immer groß geschrieben
# b)	Variablen die aus mehreren Wörtern bestehen
#    	werden mit "_" getrennt
#
# c)	Funktionen werden laut Java Konvention
#	benannt
#
###############END_KONVENTIONEN###################


#####################HILFSFUNKTIONEN##########################



function initLib(){
	tput clear
	tput cup 0 0
	let MAX_REACHED_X=0
	let MAX_REACHED_Y=0
}

function getHeightOfHost(){
	tput lines
}

function getWidthOfHost(){
	tput cols
}

function setFrameChars(){
	O_ECK_LI="$1"
	O_ECK_RE="$2"	
	U_ECK_LI="$3"
	U_ECK_RE="$4"
	SEP_LI="$5"
	SEP_RE="$6"
	VERT_LINE="$7"	
	HOR_LINE="$8"
}


#$1 and $2 are width and height of a window
#set's the variables (MAX_REACHED_X/Y)
#$3=x, $4=y
doesObjectFitsInSpace(){ #1 #2 #3 #4
	if [ $(($1+$MAX_REACHED_X + $3)) -lt $WIDTH_OF_HOST -a $(($2+$MAX_REACHED_Y+$4)) -lt $HEIGHT_OF_HOST ]; then
		let MAX_REACHED_X=$1+$MAX_REACHED_X
		let MAX_REACHED_Y=$2+$MAX_REACHED_Y
		return 0
	else
		return 1
	fi
}

#if you want to place the cursor on the coordinate, let's
#say (30, 30) you may not want to use "tput cup 40 30".
#While this command places the cursor at ( >>31<< ,40)
function moveTo(){
	tput cup $(($2-1)) $(($1-1))
}

#relative to CURRENT_X and Y_POS ...
function oneLeft(){
	let CURRENT_X_POS+=1
	tput cup $CURRENT_Y_POS $CURRENT_X_POS
}

function oneRight(){
	let CURRENT_X_POS-=1
	tput cup $CURRENT_Y_POS $CURRENT_X_POS
}

function oneUp(){
	let CURRENT_Y_POS-=1
	tput cup $CURRENT_Y_POS $CURRENT_X_POS
}

#s.a.
function oneDown(){
	let CURRENT_Y_POS+=1
	tput cup $CURRENT_Y_POS $CURRENT_X_POS
}


#############Chars############
 
O_ECK_LI="\033(0l\033(B"
O_ECK_RE="\033(0k\033(B"
U_ECK_LI="\033(0m\033(B"
U_ECK_RE="\033(0j\033(B"
SEP_LI="\033(0t\033(B"
SEP_RE="\033(0u\033(B"
VERT_LINE="\033(0x\033(B"
HOR_LINE="\033(0q\033(B"

############################

#Fragt ab ob ASCIIMODE ein ist, wenn ja, werden Chars verändert
initASCIIMode(){
	if [[ "$ASCIIMODE" != "" ]]; then
		if [[ "$ASCIIMODE" = "ascii" ]]; then
	            	O_ECK_LI="+"
	            	O_ECK_RE="+"
	            	U_ECK_LI="+"
	            	U_ECK_RE="+"
	            	SEP_LI="+"
	            	SEP_RE="+"
			VERT_LINE="|"
			HOR_LINE="-"
		fi
	fi
}

##################END_HILFSFUNKTIONEN#########################

##################VARIABLEN########################
ASCIIMODE=""
HEIGHT_OF_HOST="$(getHeightOfHost)"
WIDTH_OF_HOST="$(getWidthOfHost)"
CURRENT_X_POS="0"
CURRENT_Y_POS="0"
CURRENT_WIN_HEIGHT=""
CURRENT_WIN_WIDTH=""
MAX_REACHED_X=""
MAX_REACHED_Y=""
DOES_WINDOW_FITS_IN="true"

##################END_VARIABLEN#####################


####################HAUPTFUNKTIONEN###########################
#########################
#	PRIMITIVEN	#
#########################

#draws a line from $1, $2 with lenght $3
#where $1 and $3 are xa and xb and $2 and $4
#are ya and yb
#the line will be drawed from the given position
#downwards
drawVLine(){	
	if [ "$1" = "" -o "$2" = "" -o "$3" = "" ]; then
		return 1
	fi
	if [ $1 -le 0 -o $2 -le 0 ]; then
		return 1
	fi

	moveTo $1 $2
	for i in `seq 1 $3`; do
		echo -e $VERT_LINE
		moveTo $1 $(($2+$i))
	done
}

#s.a. will be drawed from the specified position rightwards
drawHLine(){
        if [ "$1" = "" -o "$2" = "" -o "$3" = "" ]; then
                return 1
        fi              
	if [ $1 -le 0 -o $2 -le 0 ]; then
                return 1
        fi

	moveTo $1 $2
        for i in `seq 1 $3`; do
                echo -en $HOR_LINE
        done
}

#Draws a Panel in the main winodw with
#the title $1 and the text color $2
#where $2 is a number in seq 1 256
#$3 is the width and $4 is the Height of the Window
#Note: The height and the width of the window is
#the height and the width of the frame border and
#not the content bounds...
drawWindow(){ #1 #2 #3 #4
	#testing whether the window fits in the window
	
#	doesObjectFitsInSpace $3 $4 $5 $6
#	if [ $? = 1 ]; then
#		return 1
#	fi
	
	#testing the params...
	if [ "$5" = "" -o "$6" = "" ]; then
		#if there is no specified position ($5 = x, $6 = y) 
		#the window will be drawed at the point 
		#(MAX_REACHED_X, MAX_REACHED_Y)
		X_POS=$MAX_REACHED_X
		Y_POS=$MAX_REACHED_Y
	else
		X_POS=$5
		Y_POS=$6
	fi
	
	TITLE=$1
	COLOR=$2
	WIDTH=$3
	HEIGHT=$4

	#upper left corner
	moveTo $X_POS $Y_POS

	#Start drawing window
	echo -en $O_ECK_LI
	drawHLine $(($X_POS+1)) $Y_POS $(($WIDTH-2))
	echo -en $O_ECK_RE

	moveTo $X_POS $(($Y_POS+1))
	echo -en $VERT_LINE
	moveTo $(($X_POS+$WIDTH-1)) $(($Y_POS+1))
	echo -en $VERT_LINE

	moveTo $X_POS $(($Y_POS+2))
	echo -en $SEP_LI
	drawHLine $((1+$X_POS)) $(($Y_POS+2)) $(($WIDTH-2))
	echo -en $SEP_RE

	echo 
	#the titlepart is now finished
	drawVLine $X_POS $(($Y_POS+3)) $(($HEIGHT-4))

	moveTo $X_POS $(($Y_POS+$HEIGHT-1))
	echo -en $U_ECK_LI
	drawHLine $(($X_POS+1)) $(($Y_POS+HEIGHT-1)) $(($WIDTH-2))

	echo -en $U_ECK_RE
	drawVLine $(($X_POS+$WIDTH-1)) $(($Y_POS+3)) $(($HEIGHT-4))
}

#draws a Rectangle which is $1 wide, $2 high and will be printed
#at the position $3, $4 ...
drawRect(){
	#little param testing
	if [ "$1" = "" -o "$2" = "" -o "$3" = "" -o "$4" = "" ]; then
		return 1
	fi
	
	#doesObjectFitsInSpace $1 $2 $3 $4
	#if [ $? = "1" ]; then
#		return 1
#	fi
	
	WIDTH=$1
	HEIGHT=$2
	X_POS=$3
	Y_POS=$4

	moveTo $X_POS $Y_POS
	echo -en $O_ECK_LI
	
	drawHLine $(($X_POS+1)) $Y_POS $(($WIDTH-2))
	echo -en $O_ECK_RE
	
	drawVLine $X_POS $(($Y_POS+1)) $(($HEIGHT-1))
	moveTo $X_POS $(($Y_POS+$HEIGHT-1))
	echo -en $U_ECK_LI
	
	drawHLine $(($X_POS+1)) $(($Y_POS+$HEIGHT-1)) $(($WIDTH-2))
	echo -en $U_ECK_RE
	drawVLine $(($X_POS+$WIDTH-1)) $(($Y_POS+1)) $(($HEIGHT-2))
}

#Draws the in $1 specified text centered into the current Window
#The text will be drawed with the color specified in $2
#The text will also be wrapped to fit in the window
#append(){ #1 #2}

#appendTabbed(){}



mainLoop(){
	local SLEEPTIME=1
	if [ $1 != "" ]; then
		let SLEEPTIME=$1
	fi

	while [ 1 ]; do
		main
		sleep $SLEEPTIME
	done
}

