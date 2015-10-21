#env

function env_reinstall(){
    curl -L http://bit.ly/1wg9vdQ | bash || {
        clog 1 "env_reinstall" Reinstalling failed!
        return 1
    }

    return 0
}
