. ./util.sh

install_tar()
{
    DIR=$(download TAR)
    tar -xf $DIR -C '/usr/local/src/' > '/dev/null'
    rm -rf $DIR
    FOLDER=$(ls -l '/usr/local/src/' --sort=time | tail --lines 1 | awk '{print $9}')
    cd "/usr/local/src/$FOLDER"
    ./configure
    make
    echo $1 | sudo -S make install
}

install_pkg()
{
    PASS="$1"
    NAME=$(whiptail --inputbox "What do you want to install?" 8 39 --title "Install from package manager" 3>&1 1>&2 2>&3)
    check_for_error $?
    install_dependencies $NAME $PASS "$PASS | sudo -S apt-get install $NAME -qq 2> /dev/null)"
}

install_git()
{
    URL=$(whiptail --inputbox "" 8 39 --title "Insert the url for the github repo" 3>&1 1>&2 2>&3)
    check_for_error $?
    git -C /usr/local/src  clone $URL
    cd /usr/local/src/$(basename $URL)
    ./configure
    make 
    sudo make install
}

install_deb()
{
    PASS="$1"
    DIR=$(download DEB)
    NAME=$(dpkg -I $DIR |grep Package: | cut -d ":" -f 2)
    rm -rf $DIR
    install_dependencies $NAME $PASS "$PASS | sudo -S dpkg -i $DIR &> /dev/null)"
}
