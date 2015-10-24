## 
# Reinstalls the complete environment
## 
sl-env-reinstall(){
	if [ "$1" = "--help" -o "$1" = "-h" ]; then
		cat EOL <<
usage: sl-env-reinstall 
summary: reinstalls the complete environment

EOL
	fi
	
    curl -L http://bit.ly/1wg9vdQ | bash || {
        clog 1 "env_reinstall" Reinstalling failed!
        return 1
    }

    return 0
}
