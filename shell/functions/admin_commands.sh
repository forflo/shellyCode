#Autor: Florian Mayer
#Datum: 01.10.2013
#Konventionen:
#-Die Raumnummer, auf die sich der Alias bezieht muss angegeben werden (verkuertzte Schreibweise)
#-Die Betriebssystemversion muss angegeben werden
#-Aliasse beginnen mit d
##

##
# General operations
## 
alias dWake_8A="dwake -r NTB008[Aa]"
alias dWake_8="dwake -r NTB008[0-9][0-9]"
alias dWake_7="dwake -r NTB007"
alias dWake_11="dwake -r NTB011"
alias dWake_9="dwake -r NTB009[0-9][0-9]"
alias dWake_9A="dwake -r NTB009[Aa]"

alias dSwitch_win="ln -fs ~/.ssh/known_hosts_win ~/.ssh/known_hosts"
alias dSwitch_lin="ln -fs ~/.ssh/known_hosts_lin ~/.ssh/known_hosts"

##
# Windows
##
alias dcmd_8Awin="dcmd -r NTB008[aA] -u Administrator"
alias dcmd_8win="dcmd -r NTB008[0-9][0-9] -u Administrator"
alias dcmd_7win="dcmd -r NTB007 -u Administrator"
alias dcmd_11win="dcmd -r NTB011 -u Administrator"
alias dcmd_9Awin="dcmd -r NTB009[Aa] -u Administrator"
alias dcmd_9win="dcmd -r NTB009[0-9][0-9] -u Administrator"

alias dDeployDirtree_8win="dnames -r NTB008A ; xargs -L 1 ./deploy_sysconfig.sh -d "/" -r" # --- pruefen!
alias dAutologonAuto_8win="dcmd -qs -r NTB008A -u Administrator regtool --wow64 set \"/HKEY_LOCAL_MACHINE/SOFTWARE/Microsoft/Windows\ NT/CurrentVersion/Winlogon/AutoAdminLogon\" 1"
alias dAutologonNoauto_8win="dcmd -qs -r NTB008A -u Administrator regtool --wow64 set \"/HKEY_LOCAL_MACHINE/SOFTWARE/Microsoft/Windows\ NT/CurrentVersion/Winlogon/AutoAdminLogon\" 0"

alias dEnableRdp="dcmd -qs -r NTB008A -u Administrator regtool --wow64 set \"/HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/Terminal Server/fDenyTSConnections\" 0"
alias dDisableRdp="dcmd -qs -r NTB008A -u Administrator regtool --wow64 set \"/HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/Terminal Server/fDenyTSConnections\" 1"

alias dEnableICMP="dcmd -qs -r NTB008A -u Administrator netsh firewall set icmpsetting 8 enable"
alias dDisableICMP="dcmd -qs -r NTB008A -u Administrator netsh firewall set icmpsetting 8 disable"

alias dDoUpdate="dcmd -qs -r NTB008A -u Administrator wupd.bat"

#Systemstart- und Ende
alias dReboot_8Awin="dcmd -r NTB008[aA] -qs -u Administrator shutdown -r -t 00"
alias dShutdown_8Awin="dcmd -r NTB008[aA] -qs -u Administrator shutdown -s -t 00"
alias dReboot_8win="dcmd -r NTB008[0-9][0-9] -qs -u Administrator shutdown -r -t 00"
alias dShutdown_8win="dcmd -r NTB008[0-9][0-9] -qs -u Administrator shutdown -s -t 00"
alias dReboot_7win="dcmd -r NTB007 -qs -u Administrator shutdown -r -t 00"
alias dShutdown_7win="dcmd -r NTB007 -qs -u Administrator shutdown -s -t 00"
alias dReboot_11win="dcmd -r NTB011 -qs -u Administrator shutdown -r -t 00"
alias dShutdown_11win="dcmd -r NTB011 -qs -u Administrator shutdown -s -t 00"
alias dReboot_9win="dcmd -r NTB009[0-9][0-9] -qs -u Administrator shutdown -r -t 00"
alias dShutdown_9win="dcmd -r NTB009[0-9][0-9] -qs -u Administrator shutdown -s -t 00"

##
# Linux
##
alias dcmd_8Alin="dcmd -r NTB008[aA] -u root"

#Gnome settings
alias dDisableLockscreen_8Alin="dcmd -u betrisys -r NTB008[aA] -qs export DISPLAY=:0 ; gsettings set org.gnome.desktop.lockdown disable-lock-screen"
alias dSetAutologin_8Alin="dcmd -r NTB008[aA] -u root -qs /usr/lib/lightdm/lightdm-set-defaults --autologin betrisys"
alias dSetMonitorIdleTime_8Alin="dcmd -r NTB008[Aa] -u betrisys  export DISPLAY=:0 ; gsettings set org.gnome.desktop.session idle-delay"
alias dFunk_8Alin="while :; do sleep \$(random_simple $OG); ./set_background_picture.sh -r -e NTB008A; done  "


alias dDisableGuestLogin_8Alin="dcmd -r NTB008[aA] -u root -qs /usr/lib/lightdm/lightdm-set-defaults --allow-guest false"
alias dUpdateGrub_8Alin="dcmd -qs -u root -r NTB008[Aa] update-grub"
alias dGrubSetDefault_8Alin="dcmd -qs -u root -r NTB008[aA] grub-set-default"

alias dBootwin_8Alin="dcmd -qs -r NTB008[aA] -u root grub-reboot 4" 

alias dShutdown_8Alin="dcmd -r NTB008[aA] -qs -u root shutdown -h now"
alias dReboot_8Alin="dcmd -r NTB008[aA] -qs -u root shutdown -r now"
alias dDeployDirtree_8Alin="dnames -r NTB008A | xargs -L 1 ./deploy_sysconfig.sh -d "/" -r"

##
# Admin functions
##
# Create folder and chowns/chmods it to user
# The folder is created in the current directory
# foo
# Params:
#   $1: name of the folder
#   $2: name of the user
#   $3: name of the group (optional)
##
mkdir_chown(){
	local mask="700"
	local group="$2"
	if [ $# -lt 2 ]; then
		return 1
	fi
	if [ -n "$3" ]; then
		group="$3"
	fi

	mkdir "$1"
	if [ "$group" != "$2" ]; then
		sudo chown -R "$2":"$group" "$1"
	else 
		sudo chown -R "$2" "$1"
	fi
	sudo chmod -R $mask "$1"

	return 0
}

##
# chown and chmod folder to given user
# Params:
#   $1: name of the folder
#   $2: name of the user
#   $3: name of the group (optional)
##
dir_chown(){
	local group=""
	local mask="700"
	if [ $# -lt 2 ]; then
		return 1
	fi
	if [ -n "$3" ]; then
		group="$3"
	fi

	# if group has been set, use that value
	if [ -n "$group" ]; then
		sudo chown -R "$2":"$group" "$1"
	else
		sudo chown -R "$2" "$1"
	fi
	sudo chmod -R $mask "$1"

	return 0
}

##
# Show host sshd fingerprints
##
sshd_show_fingerprints(){
	echo +showing this hosts fingerprints
	for file in /etc/ssh/ssh_host*; do
		ssh-keygen -lf $file || {
			echo +error while executing ssh-keygen
			return 1
		}
	done
	echo +finished calculating fingerprints

	return 0
}

##
# Deploys given ssh public key on a remote machine.
# If no user name is given, root is assumed.
# Params:
#   $1: path to ssh-key
#   $2: remote host
#   $3: ssh port
#   $4: user
# Return:
#   0 on success and 1 on failure
##
deploy_host_key(){
	local port_scp_param="-P $3"
	local port_ssh_param="-p $3"
	local tmp_fname=$(($RANDOM+$RANDOM))
	local user="root"
	if [ $# -lt 2 -o ! -f "$1" ]; then
		return 1
	fi

	if [ -n "$4" ]; then
		user="$4"	
	fi
	
	echo +deploying key \["$1"\] on host \["$2"\]
	echo +copying key
	if [ $user = "root" ]; then
		scp $port_scp_param "${1}" root@${2}:/root/.ssh/${tmp_fname} || {
			echo +folder propably missing. Creating it
			ssh $port_ssh_param root@${2} "mkdir /root/.ssh/"
			scp $port_scp_param "${1}" root@${2}:/root/.ssh/${tmp_fname}
		}

		ssh $port_ssh_param root@${2} "cat /root/.ssh/${tmp_fname} >> \
			/root/.ssh/authorized_keys" || {
			echo +error while appending the key to authorized_keys
			return 1	
		}

		echo +removing temporary copy
		ssh $port_ssh_param root@${2} "rm /root/.ssh/${tmp_fname}" || {
			echo +error while removing tempfile
			return 1
		}
	else
		scp $port_scp_param "${1}" root@${2}:/home/${user}/.ssh/${tmp_fname} || {
			echo +folder propably missing. Creating it
			ssh $port_ssh_param root@${2} "mkdir /home/${user}/.ssh/"
			scp $port_scp_param "${1}" root@${2}:/home/${user}/.ssh/${tmp_fname} || {
				echo +creating the folder /home/${user}/.ssh did not help
				return 1
			}
		}

		ssh $port_ssh_param root@${2} "cat /home/${user}/.ssh/${tmp_fname} >> \
			/home/${user}/.ssh/authorized_keys" || {
			echo +error while appending the keyfile to authorized_keys
			return 1
		} 
		echo +removing temporary copy
		ssh $port_ssh_param root@${2} "rm /home/${user}/.ssh/${tmp_fname}" || { 
			echo +error while removing the tempfile
			return 1
		}
	fi
	
	if [ $user = "root" ]; then
		echo +finished installing key in folder
		echo +/root/.ssh/
	else
		echo +finished installing key in folder
		echo +/home/${user}/.ssh/${tmp_fname}
	fi
}
