#!/bin/bash

#Global Vars and Arrays
MAC_ARRAY=()
COMP_NAMES=()
IP_ARRAY=()
MACIPCOMPFile=
PROMT="--->  "
USER="Administrator"
PORT="7779"
FILE="tFC.txt"
TMPFILENAME=$RANDOM 	#Ths value later is used for identifying the tmpfiles generated in the
			#procedure called mainSendCmd ...
TMPDIR=/tmp/

#other useful things
TRENNLINIE="###################################################################"
USERHELP="usage: adminTool.sh [ -q ] [ [ -s ] --sendfile datafile.txt | [ -s ]--sendCmd | --wakeup [ ms ] | --shutdown ] "

#sendet einen Befehl zu einem ssh Server
#Befehl $1, IP-Addr des Servers $2, Port $3, User $4 
#this command will fail if only password
#authentication is possible
#To succeed it is important that you have your
#accounds private key installed on the
#remote machine in the file ~/.ssh/authorized_keys
#The ssh-add command must be executed before the
#rsa authentication
sendCommand(){
	if [ ! -f ~/.ssh/id_rsa -o $# -ne 4 ]; then
		return 1
	fi
	ssh -p $3 $4@$2 "$1"
}

sendCommandSimultan(){
	if [ ! -f ~/.ssh/id_rsa -o $# -ne 4 ]; then
		return 1
	fi
	ssh -f -p $3 $4@$2 "$1" > /dev/null
}

sendCommandSimultanLoud(){
	if [ ! -f ~/.ssh/id_rsa -o $# -ne 4 ]; then
                return 1
        fi
        ssh -f -p $3 $4@$2 "$1"
}

#include <stdio.h>
#include <string.h>

int main(void){
	int abefawer=0;
	
	if (!abefawer) {

		>>#!bash
			init(){
				local USERTEXT="Bitte geben Sie den Standort der Datei an, die\n \
					die Computernamen, Mac-Addressen und IP_Addressen\n \
					der zu administrierenden Rechner enthält"
				local USERHELP="Jede Zeile der angegebenen Datei muss folgendem Muster\n \
					entsprechen: Computername, IP, MAC\n"
				local USERFAIL="Bitte geben Sie einen gültigen Dateinamen ein !"
				echo -e $USERTEXT
				while [ 1 ]; do
					read -p $PROMT TOREAD
					if [ -f "$TOREAD" ]; then
						readFile $TOREAD
						break;
					elif [ "$TOREAD" = "exit" ]; then
						return 1
					elif [ "$TOREAD" = "help" ]; then
						echo -e $USERHELP
					elif [ "$TOREAD" = "" ]; then
						echo $USERFAIL
					else
						echo $USERFAIL
						continue
					fi
				done
			}
		<<
	
	else {
		
		echo
	
	}

	return 0
}

#include <stdio.h>
#include <string.h>

int main(void){
	int abefawer=0;
	
	if (!abefawer) {

		[[[#!(bash)
			init(){
				local USERTEXT="Bitte geben Sie den Standort der Datei an, die\n \
					die Computernamen, Mac-Addressen und IP_Addressen\n \
					der zu administrierenden Rechner enthält"
				local USERHELP="Jede Zeile der angegebenen Datei muss folgendem Muster\n \
					entsprechen: Computername, IP, MAC\n"
				local USERFAIL="Bitte geben Sie einen gültigen Dateinamen ein !"
				echo -e $USERTEXT
				while [ 1 ]; do
					read -p $PROMT TOREAD
					if [ -f "$TOREAD" ]; then
						readFile $TOREAD
						break;
					elif [ "$TOREAD" = "exit" ]; then
						return 1
					elif [ "$TOREAD" = "help" ]; then
						echo -e $USERHELP
					elif [ "$TOREAD" = "" ]; then
						echo $USERFAIL
					else
						echo $USERFAIL
						continue
					fi
				done
			}
		]]]
	
	else {
		
		echo
	
	}

	return 0
}

#$1 is the path of the file to read
readFile(){
    local ADMINFILE="$1"
    local lines=$(cat $ADMINFILE | wc -l | sed s/" "//g)

    for i in $( seq 0 $(($lines-1)) ); do
        local string=$(cat $ADMINFILE | head -n $(($i+1)) | tail -n 1)

	COMP_NAMES[$i]=$(echo $string | awk '{printf "%s\n",$1}')
        IP_ARRAY[$i]=$(echo $string | awk '{printf "%s\n", $2}')
        MAC_ARRAY[$i]=$(echo $string | awk '{printf "%s\n", $3}')
    done
}

mainSendCmd(){
	echo -e "\nKommandos simultan übertragen ? (yes/no)"
	read -p $PROMT COMMAND
	if [ "$COMMAND" = "no" ]; then
		while [ 1 ]; do
			read -p $PROMT COMMAND
			if [ "$COMMAND" = "exit" ]; then
				break
			fi
			for i in `seq 0 $((${#IP_ARRAY[*]} - 1))`; do
   				echo -e "\n"
    				echo ssh -p $PORT $USER@${IP_ARRAY[$i]} "$COMMAND" "   " AKA: ${COMP_NAMES[$i]}
    				echo $TRENNLINIE
				sendCommand "$COMMAND" "${IP_ARRAY[$i]}" "$PORT" "$USER"
			done
    			echo -e "\n"
		done
	elif [ "$COMMAND" = "yes" ]; then
		echo -e "Ergebnise ausgeben ? (yes/no)"
		read -p $PROMT COMMAND
		if [ "$COMMAND" = "yes" ]; then
			echo -e "Kommando ausgaben werden gezeigt !"
                        while [ 1 ]; do
                                read -p $PROMT COMMAND
                                if [ "$COMMAND" = "exit" ]; then
                                        break
                                elif [ "$COMMAND" = "" ]; then
					continue #
				fi
				#sende Kommandos ...
                                for i in `seq 0 $((${#IP_ARRAY[*]} - 1))`; do
					FILE=${TMPDIR}TMP${i}.$TMPFILENAME
					echo Kommando: " " $COMMAND " " an den Rechner: " " ${COMP_NAMES[$i]} > $FILE
					echo $TRENNLINIE >> $FILE 
                                        sendCommandSimultanLoud "$COMMAND" "${IP_ARRAY[$i]}" "$PORT" "$USER" >> $FILE &
				done
				#teste ob die Kommandos noch laufen	
				sleep 0.8
				while [ $(ps -ef | grep "ssh " | wc -l) = "$((${#IP_ARRAY[*]} + 1))" ]; do
					sleep 0.5
					echo wait ...
				done
				sleep 1.5 
				#Wenn die Schleife beendet ist, dann sind
				#auch die Ausgaben fertig, also Kommandoausgaben 
				#aus den Dateien auf die Stdout schreiben 
				for i in `seq 0 $((${#IP_ARRAY[*]} - 1))`; do
					cat ${TMPDIR}TMP${i}.$TMPFILENAME
					echo
					rm ${TMPDIR}TMP${i}.$TMPFILENAME
				done
                        done
		else
			echo -e "Kommando ausgaben werden nicht gezeigt !"
			while [ 1 ]; do
                	        read -p $PROMT COMMAND
                	        if [ "$COMMAND" = "exit" ]; then
                	                break
                	        fi
                	        for i in `seq 0 $((${#IP_ARRAY[*]} - 1))`; do
                	                sendCommandSimultan "$COMMAND" "${IP_ARRAY[$i]}" "$PORT" "$USER" > /dev/null &
                	        done
                	done
		fi
	else
		mainSendCmd
	fi
}

mainSendFile(){
	local USERTEXT="Bitte geben Sie nacheinander Quell und Ziel Datei bzw Ordner an !"
	local USERFAIL="Bitte geben Sie einen gültigen String ein !"
	local SWITCH
	while [ 1 ]; do
		read -p "Quelle $PROMT" SOURCE
		if [ -f "$SOURCE" ]; then
			SWITCH=""
		elif [ "$SOURCE" = "exit" ]; then
			break
		else
			SWITCH=" -r "
		fi
		read -p "Ziel 	$PROMT" DEST
		read -p "schnell übertragen [yes/no] ? " READING
		if [ "$READING" = "yes" ]; then
			for i in `seq 0 $((${#IP_ARRAY[*]} - 1))`; do
				echo
				echo sende Datei an: ${IP_ARRAY[$i]}
				scp -P $PORT $SWITCH $SOURCE $USER@${IP_ARRAY[$i]}:"$DEST" > /dev/null &
			done
		elif [ "$READING" = "no" ]; then
			for i in `seq 0 $((${#IP_ARRAY[*]} - 1))`; do
                        	echo
                        	echo sende Datei an: ${IP_ARRAY[$i]}
                        	echo $TRENNLINIE
                        	scp -P $PORT $SWITCH $SOURCE $USER@${IP_ARRAY[$i]}:"$DEST"
                	done
		else
			echo $USERFAIL
		fi
	done
}

mainWakeUp(){
	echo Geben Sie den zeitlichen Versatz der Magic-Pakets in Sekunden an
	read -p $PROMT TIME
	for i in `seq 0 $((${#MAC_ARRAY[*]} - 1))`; do
		wakeonlan ${MAC_ARRAY[$i]}
		sleep $TIME
	done
    echo
}

mainShutdown(){
    echo
    if [ $USER != "root" -a $USER != "Administrator" ]; then
        echo Sie sind nicht berechtigt dieses Kommando zu geben !
    else
        for i in `seq 0 $((${#IP_ARRAY[*]} - 1))`; do
            sendCommand "shutdown -s -t 00" "${IP_ARRAY[$i]}" "$PORT" "$USER" &
            echo ${COMP_NAMES[$i]} goes down ...
        done
    fi
    echo
}

testSshAdd(){
    	if [ "$(ssh-add -L)" = "The agent has no identities." ]; then
        	ssh-add
    	fi
}

main(){
	testSshAdd
	local USERTEXT="Vorhandene Befehle:\n\nsendcmd\nsendfile\nwakeup\nshutdown\nexit\n"
	clear
	init
    	if [ $? -eq 1 ]; then
        	exit
    	fi
	clear
	while [ 1 ]; do
        echo -e $USERTEXT
		read -p $PROMT READING
		if [ "$READING" = "exit" ]; then
			clear
			exit
		elif [ "$READING" = "" ]; then
			continue;
		elif [ "$READING" = "shutdown" ]; then
			mainShutdown
		elif [ "$READING" = "sendcmd" ]; then
			mainSendCmd
		elif [ "$READING" = "wakeup" ]; then
			mainWakeUp
		elif [ "$READING" = "sendfile" ]; then
			mainSendFile
		else
			continue
		fi
	done
}

onKill(){
	echo "Exiting"
	for i in `seq 0 $((${#IP_ARRAY[*]} - 1))`; do
		rm ${TMPDIR}TMP${i}.$TMPFILENAME > /dev/null
	done	
	exit
}

trap onKill SIGINT SIGTERM

printHelp(){
cat << EOF

Moegliche Optionen im nicht interativen Modus sind:
###################################################

--sendfile datafile dest
	sendet eine Datei oder einen Ordner zum Zielort auf den
	registrierten Computern ...
--sendcmd cmd
	sendet ein Kommando an alle registrierten Computer simultan
	ohne Ausgaaben anzuzeigen
--wakeup ms
	faehrt alle registrierten Computer hoch ...
--shutdown
	faehrt alle registrierten Computer herunter ...
--help
	gibt diesen Text aus ...


$USERHELP

EOF
}

#Parse Commandline Arguments ...
#usage: adminTool.sh [ -q ] [ --sendfile datafile.txt dest | --sendcmd cmd | --wakeup  ms  | --shutdown ]
#cmd has to be a string !!
if [ $# -ge 1 ]; then
	readFile $FILE
	if [ "$1" = "--sendcmd" -a ! "$2" = "" ]; then
		testSshAdd
		for i in `seq 0 $((${#IP_ARRAY[*]} - 1))`; do
               		sendCommandSimultanLoud "$2" "${IP_ARRAY[$i]}" "$PORT" "$USER" &
       		done
	elif [ "$1" = "--sendfile" -a ! "$2" = "" -a ! "$3" = "" ]; then
		testSshAdd
		SWITCH=
		if [ -d "$2" ]; then
			SWITCH=" -r "
		else
			SWITCH=" "
		fi
		for i in `seq 0 $((${#IP_ARRAY[*]} - 1))`; do
                      	scp -P $PORT $SWITCH "$2" $USER@${IP_ARRAY[$i]}:"$3" &
		done
	#works ^^
	elif [ "$1" = "--wakeup" -a ! "$2" = "" ]; then
		for i in `seq 0 $((${#MAC_ARRAY[*]} - 1))`; do
                	wakeonlan ${MAC_ARRAY[$i]}
                	sleep $2
        	done
	elif [ "$1" = "--shutdown" ]; then
		testSshAdd
		mainShutdown
	elif [ "$1" = "--help" ]; then
		printHelp
	elif [ "$1" = "-q" ]; then
		if [ "$2" = "--wakeup" -a ! "$3" = "" ]; then
			for i in `seq 0 $((${#MAC_ARRAY[*] - 1}))`; do
				wakeonlan ${MAC_ARRAY[$i]} &> /dev/null
				sleep $3
			done
		elif [ "$2" = "--shutdown" ]; then
			testSshAdd
			mainShutdown > /dev/null
		elif [ "$2" = "--sendcmd" -a ! "$3" = "" ]; then
			testSshAdd
                	for i in `seq 0 $((${#IP_ARRAY[*]} - 1))`; do
                        	sendCommandSimultan "$3" "${IP_ARRAY[$i]}" "$PORT" "$USER" &
                	done
		elif [ "$2" = "--sendfile" -a ! "$3" = "" -a ! "$4" = "" ]; then
			testSshAdd
                	SWITCH=
                	if [ -d "$3" ]; then
                        	SWITCH=" -r "
                	else
                        	SWITCH=" "
                	fi
                	for i in `seq 0 $((${#IP_ARRAY[*]} - 1))`; do
                        	scp -P $PORT $SWITCH "$3" $USER@${IP_ARRAY[$i]}:"$4" > /dev/null &
                	done
		else
			echo
			echo Zu wenige Kommandozeilenargumente ...
			printHelp
		fi
	fi
else
	main
fi
