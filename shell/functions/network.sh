#Autor: Florian Mayer
#Datum: 21.Okt.2013
#Zweck: Stellt Funktionen und aliasse zur Verfügung die auf das
#		Netzwerkverhalten abzielen
#Präfix: net
##


alias netspoofmac="sudo ifconfig en0 ether 08:00:27:69:02:D4; sudo ifconfig en0 up"
alias netspoofmac_rand="sudo ifconfig en0 ether \$(gen_mac_add) ; sudo ifconfig en0 up"

gen_mac_add(){
	local result=
	for ((net_i=0; net_i<6; net_i++)); do
		local temp=$RANDOM
		if [ $temp -gt 9 ]; then
			if [ $net_i -eq 0 ]; then
				result=${temp:0:2}
			else
				result=$result:${temp:0:2}
			fi
		else
			((net_i--))
		fi
	done
	echo $result
}

ping_subnet(){
	local prefix=${1}
	for i in {0..255}; do
		if ping -W 0.1 -c 1 ${prefix}.${i} > /dev/null 2>&1; then
			echo Ping to ${prefix}.${i} was successful
		else
			echo Ping to ${prefix}.${i} was not successful
		fi &
	done
}
