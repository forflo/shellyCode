#penus

function penus-flo(){
    curl -k -L "http://tartaros.mooo.com/cgi-bin/penout.lua?cb2=on&s=$1" &> /dev/null
}

function penus-lars(){
    curl -k -L "http://tartaros.mooo.com/cgi-bin/penout.lua?cb1=on&s=$1" &> /dev/null
}

