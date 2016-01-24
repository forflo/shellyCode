#!/bin/bash
# Contains routines for managing the TeXLive
# installation, package installation, package
# removal and reindexing of the TexLive filebase
# Author: Florian Mayer
# Date 17-22.7.2014
# Documentation: texlive_package.txt
##

##
# Installs the given package url on your system
# Param
#   $1: package name
#   $2: package url
# Return
#   0: on success
#   1: on failure
# Depends
#   * platform.sh 
##
latex_install_package(){
	if [ -z "$1" ]; then
		return 1
	fi
	# clear the directory stack
	# the current directory remains on the stack
	dirs -c

	# you can adjust that if you like
	local rights=755
	local td=$(mktemp -d)
	local tf="$1".zip
	local tfl="$1"
	pushd $td
	
	# download, unzip and process package inside of a
	# temporary directory
	echo download package "$1"
	curl -o $tf "$2" || { 
		echo could not fetch the package; popd
		rm -rf $td; return 1 
	}

	echo unzip file $td/$tf
	unzip $tf || { 
		echo could not unzip the downloaded package; popd
		rm -rf $td; return 1
	}

	# change into directory created by unzipping the downloaded
	# package
	pushd $tfl/
	echo process file $td/$tfl/*.ins
	pdflatex "$1".ins || {
		echo could not process package ins-file; popd; popd
		rm -rf $td; return 1
	}

	# get path for tex-makro packages (os dependent)
	local path_dist=$(sl-onos archlinux "/usr/share/texmf-dist/" \
						darwin "$HOME/Library/texmf/" \
						cygwin7 "$HOME/texmf/" \
						cygwinxp "$HOME/texmf/")

	# get path for makro package documentation (os dependent)
	local path_doc=$path_dist/doc/"$1"
	local path_prog=$path_dist/tex/latex/"$1"

	echo make package directory for the makro and documentation file
	sudo mkdir $path_prog $path_doc || {
		echo could not create new directory
		rm -rf $td; popd; popd; return 1	
	}

	echo copy makro-file $1.sty to $path_prog
	sudo cp "$1".sty $path_prog || {
		echo copying of makro-file was not successful; popd; popd
		rm -rf $td; return 1
	}

	echo copy documentation $1.pdf to $path_doc
	sudo cp "$1".pdf $path_doc || {
		echo copying of documentation was not successful; popd; popd
		rm -rf $td; return 1
	}

	echo adjusting rights
	sudo chmod -R $rights $path_doc $path_prog || {
		echo adjusting rights failed
		rm -rf $td; popd; popd; return 1
	}

	popd
	popd

	echo remove tempdir $td
	rm -rf $td || { 
		echo could not remove tempdir: $td;
		return 1
	}
	return 0
}

##
# Removes the given package from your system
# Param
#   $1: package name (e.g. dottex)
# Return
#   0: on success
#   1: on failure
# Depends
#   * platform.sh
##
latex_remove_package(){
	if [ -z "$1" ]; then
		return 1
	fi	

	# get path for tex-makro packages (os dependent)
	local path_dist=$(sl-onos archlinux "/usr/share/texmf-dist/" \
						darwin "$HOME/Library/texmf/" \
						cygwin7 "$HOME/texmf/" \
						cygwinxp "$HOME/texmf/")

	# get path for makro package documentation (os dependent)
	local path_doc=$path_dist/doc/"$1"
	local path_prog=$path_dist/tex/latex/"$1"
	
	# remove files
	echo remove $path_prog
	sudo rm -rf $path_prog || {
		echo could not remove makro package 
		return 1
	}

	echo remove $path_doc/
	sudo rm -rf $path_doc || {
		echo could not remove documentation
		return 1
	}

	return 0
}

##
# Updates the TeX/LaTeX package index using the
# environment variable $TEXMFDIST
# Return:
#   0: on success
#   1: on failure
# Param: 
#   <nothing>
##
latex_update_package_index(){
	echo updating the TeX/LaTeX package index
	if ! which texhash; then
		echo program \"texhash\" not installed. stop
		return 1
	fi
 	sudo texhash || {
		echo texhash ran into an error. stop
		return 1
	}	
	return 0
}
