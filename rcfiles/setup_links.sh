[ -f ~/.zprofile ] && mv ~/.zprofile ~/.zprofile.old
[ -f ~/.profile ] && mv ~/.profile ~/.profile.old

ln -s $PWD/zsh/zprofile ~/.zprofile
ln -s $PWD/bash/profile ~/.profile
