. ./util.sh

install_tar()
{
    DIR=$(download TAR)
    tar -xf $DIR -C '/usr/local/src/' > '/dev/null'
    rm $DIR
    FOLDER=$(ls -l '/usr/local/src/' --sort=time | tail --lines 1 | awk '{print $9}')
    cd "/usr/local/src/$FOLDER"
    ./configure
    make
    echo $1 | sudo -S make install
}

install_pkg()
{
    NAME=$(whiptail --inputbox "What do you want to install?" 8 39 --title "Install from package manager" 3>&1 1>&2 2>&3)
    install_dependencies $NAME "$1 | sudo -S dpkg -i $DIR -qq 2> /dev/null)"
}

install_git()
{
    URL=$(whiptail --inputbox "" 8 39 --title "Insert the url for the github repo" 3>&1 1>&2 2>&3)
    git -C /usr/local/src  clone $URL
    cd /usr/local/src/$(basename $URL)
    ./configure
    make 
    sudo make install
}

install_deb()
{
    DIR=$(download DEB)
    NAME=$(dpkg -I $DIR |grep Package: | cut -d ":" -f 2)
    rm $DIR
    install_dependencies $NAME "$1 | sudo -S dpkg -i $DIR -qq 2> /dev/null)"
}
