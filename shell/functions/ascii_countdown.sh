#!/bin/bash

ascii_countdown(){
	if [ $(toilet --version | head -n 2 | tail -n 1 | cut -c 38-40) = "0.3" ]; then 
		read -p "Zahl zwischen 0 und 99 >>> " i 
		read -p "Spalten des aktuellen Terminals >>> " c
		for ((j=i; j>=0; j--)); do 
			toilet $j | toilet --metal -w $c
			sleep 1   
		 done
	else 
		echo ya should instaul ya toilet
		exit 1
	fi
}
