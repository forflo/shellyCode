sl-uninstall-macports(){
	[] && {
		cat << EOL
usage: sl-uninstall-macports
       => uninstalls the macports package from a
          os x system
EOL	
		return 0
	}

	sudo port -fp uninstall --follow-dependents installed

	sudo rm -rf \
	    /opt/local \
	    /Applications/DarwinPorts \
	    /Applications/MacPorts \
	    /Library/LaunchDaemons/org.macports.* \
	    /Library/Receipts/DarwinPorts*.pkg \
	    /Library/Receipts/MacPorts*.pkg \
	    /Library/StartupItems/DarwinPortsStartup \
	    /Library/Tcl/darwinports1.0 \
	    /Library/Tcl/macports1.0 \
	    ~/.macports

	return 0
}
