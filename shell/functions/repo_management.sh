##
# git
##
alias "gs"="git status --short"
alias "gb"="git branch"
alias "gco"="git checkout"
alias "gl"="git log --no-merges -n 20 --date=local --pretty=format:\"Commit: %Cblue%H %Creset-> %Cgreen%an %Creset-> %Cred%ad |  %Creset\\\"%s\\\"\""
alias "gc"="git commit -am"
alias "gpush"="git push"
alias "gpull"="git pull"
alias "gh"="git help"
alias "ga"="git add"

##
# mercurial
##
alias "hs"="hg status"
alias "hc"="hg commit"
alias "ha"="hg add"

##
# Creates a bare repository in the current directory
# Param:
#   <void>
# Return:
#   0: on success
#   1: on failure
##
function git_create_bare(){
	echo "Name des Repos: "
	read repo
	mkdir "$repo" || {
		echo failed to create folder
		return 1
	} 
	cd "$repo"
	git init --bare || {
		echo "failed to create bare repo using [git init --bare]"
		return 1
	}
	cd $OLDPWD
	return 0
}

##
# Commits every change in every repo in repos/git/
# Param:
#   $1: If not empty, this specifies the message usead
#		for all commits
# Return: 
#   0: on success
#   1: on failure
##
function git_commit_all(){
	if [ -n "$1" ]; then
		local cmsg="$1"
	fi

	echo +storing current path
	local cpwd="$PWD"
	echo +changing in repo path
	cd $REPOS_PATH/git
	echo +committing all changes in every git repo
	echo +\( * \)
	for i in *; do
		echo ++entering repo "$i"
		cd "$i"

		echo ++adding all changes in repo "$i"
		git add -A
		echo ++please enter your commit message!
		if [ -z "$cmsg" ]; then
			read cmsg
		else
			echo ++using commit message [$cmsg]
		fi
		git commit -m "$cmsg"
		
		echo ++rommiting done
		echo ++leaving directory "$i"
		cd ..
	done
	
	echo +restoring previous path
	cd "$cpwd"

	return 0
}

##
# Pushes all repos to upstream inside of repos/git/
# Param:
#   $1 upstream to use
# Return:
#   0: on success (especially if every repo could be pushed)
#   1: on failure (just one push-failure is 
#		sufficient to let the function fail)
##
function git_push_all(){
	if [ -n "$1" ]; then	
		return 1
	else 
		local upstream="${1}"
	fi

	echo saving current dir
	local cpwd="$PWD"
	echo changing in  repodir
	cd $REPOS_PATH/git
	echo doing a collective commit
	git_commit_all "unattended collective push commit" || {
		echo collective commit went wront. abort!
		return 1
	}

	echo collective commit successful...
	echo

	for i in *; do
		echo entering repo "$i"
		cd "$i"

		echo pushing everything into the upstream [$upstream]
		git push $upstream master
#		for j in $(git remote); do
#			echo +++Pushing to remote: "[$j]" in Repo: "[$i]" onto master
#			git push "$j" master
#			echo +++Pushing done
#		done
		echo leaving directory "$i"
		cd ..
	done
	echo restoring previous dir
	cd "$cpwd"
	
	return 0
}

##
# Pushes all repos to <<all>> upstreams. Repos lay inside of repos/git/
# Param:
#   <void>
# Return:
#   0: on success (especially if every repo could be pushed)
#   1: on failure (just one push-failure is 
#		sufficient to let the function fail)
##
function git_push_all(){
	echo saving current dir
	local cpwd="$PWD"
	echo changing in  repodir
	cd $REPOS_PATH/git
	echo doing a collective commit
	git_commit_all "unattended collective push commit" || {
		echo collective commit went wront. abort!
		return 1
	}

	echo collective commit successful...
	echo

	for i in *; do
		echo entering repo "$i"
		cd "$i"

		echo pushing everything...
		for j in $(git remote); do
			echo pushing to remote: "[$j]" in Repo: "[$i]" onto master
			git push "$j" master || {
				echo pushing failed
				return 1
			}
			echo done
		done

		echo leaving directory "$i"
		cd ..
	done
	echo restoring previous dir
	cd "$cpwd"
	
	return 0
}

##
# Collective pull for all repos inside of repos/git/
# Param: 
#   $1: upstream to use. Has to be set
# Return:
#   0: on success
#   1: on failure
##
function git_pull_all(){
	if [ -n "${1}" ]; then
		return 1
	else
		local upstream="${1}"
	fi

	echo saving current dir
	local cpwd="$PWD"
	echo changing in repodir
	cd $REPOS_PATH/git
	
	echo pulling from all repos [upstream: ${upstream}]
	echo \( * \)
	for i in *; do
		if [ ! -d "${i}" ]; then
			echo ++${i} is no directory
			continue
		fi
		
		cd "${i}"
		echo pulling for repo ${i}
		git pull ${i} master || {
			echo pulling failed
			return 1
		}

		echo finished pulling for repo ${i}
		cd ..
	done

	echo restore previous dir
	cd "$cpwd"

	return 0
}
