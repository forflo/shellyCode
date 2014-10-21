#Prompt-Art
SUFFIX="prompt_art_"
PFAD=~/repos/git/shellyCode/data/prompt_art
FILE="$SUFFIX$(random_simple $(ls $PFAD/* | wc -l)).txt"
LINE_COUNT=$(cat "$PFAD"/$FILE | wc -l)
COUNT=0

#Konfiguration
ART_ON="off"
COLOR="random"
COLOR_DATA=$(random_color)
ROTATE="off"
BLINK="off"

##
# Funktionen
##
#Prompt-Art
prompt_art(){
	if [ $ART_ON = "on" ]; then 
		let COUNT++  
		if ((COUNT % LINE_COUNT == 0)); then
			if [[ $COLOR == random ]]; then
				COLOR_DATA=$(random_color)
			else
				COLOR_DATA=$(random_color_extended)
			fi
			if [[ $ROTATE == "on" ]]; then
				p_change_art
			fi
		fi
		if [[ $BLINK == on ]]; then
			echo -n $TERM_BLINK
		fi

		if [[ $COLOR == gay ]]; then
			random_color
		elif [[ $COLOR == random ]]; then 
			echo -n $COLOR_DATA
		elif [[ $COLOR == "gay-ext" ]]; then
			random_color_extended
		elif [[ $COLOR == "random-ext" ]]; then
			echo -n $COLOR_DATA
		else 
			: #Use standard color
		fi
		get_line ${PFAD}${FILE} $(($COUNT % $LINE_COUNT)) 
		term_reset
	fi
}

p_change_art(){
	FILE="$SUFFIX$(random_simple $(ls $PFAD/* | wc -l)).txt"
	LINE_COUNT=$(cat "$PFAD"/$FILE | wc -l)
	COUNT=0
}

##
# Convenience functions
##
#Schaltet prompt_art an 
p_on(){
	ART_ON="on"
}

#Schaltet prompt_art aus 
p_off(){
	ART_ON="off"
	term_reset
}

p_blink_on(){
	BLINK="on"
}

p_blink_off(){
	BLINK="off"
}

#Farbe je Zeile ändern
p_gay(){
	COLOR="gay"	
}

#Farben nur pro Bilddurchlauf verändern
p_random(){
	COLOR="random"
}

#Farben der standard Terminal konfiguration verwenden!
p_normal(){
	COLOR="normal"
}

#Farben der xterm-256 Farbpalette verwenden
p_random_ext(){
	COLOR="random-ext"
}

#Farben der xterm-256 Farbpalette verwenden
p_gay_ext(){
	COLOR="gay-ext"
}

#Schaltet Bildrotationsmodus an
p_rot_on(){
	ROTATE=on
}

#Schaltet Bildrotationsmodus aus
p_rot_off(){
	ROTATE=off
}
