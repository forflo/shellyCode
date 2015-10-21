#explain
function explain(){
    firefox "http://explainshell.com/explain?cmd=$(python2 -c "import sys, urllib as ul; print ul.quote_plus(\"$(echo $@)\")")"
}

