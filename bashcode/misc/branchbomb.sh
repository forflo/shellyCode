#Autor: Florian Mayer
#Datum: ~18.August.2013
#
#Eine Branchbombe
#(Sollte) einen binären Baum aus Branches bauen ...
#!/bin/bash

create_node(){
	git checkout "$1"
	randtemp=$(($RANDOM+$RANDOM*3))
	echo abc >> abc${randtemp}${randtemp}
	git add abc${randtemp}${randtemp} 
	git commit -m "unuseful message nr $randtemp -> $randtemp" 
}


branching(){ 
	if [ "$1" -gt 0 ]; then
		rand1=$(($RANDOM*$RANDOM))
		rand2=$((RANDOM*$RANDOM))  
		#create branches
		git branch $rand1 && git branch $rand2

		#complete first random node
		create_node $rand1

		#complete second random node
		create_node $rand2 

		#complete recursion
		git checkout $rand1
		branching $(echo $(($1-1)))
		git checkout $rand2 
		branching $(echo $(($1-1)))
	else
		return
	fi
}

branching "$1"
