#/bin/bash
#usage: $0 Volumenname
#Volumenname = <Volumenname> 

eject_volume(){
	if [ $(uname) != "Darwin" ]; then
		echo Sie befinden sich nicht auf einem MacOSX System!
		return 1 
	fi

	if [ "$1" = "" ]; then
		echo Fehlender Parameter
		return 1	
	fi

	diskutil eject "$1"
}
