gitinstall()
{
    URL=$(whiptail --inputbox "" 8 39 --title "Insert the url for the github repo" 3>&1 1>&2 2>&3)
    git -C /usr/local/src  clone $URL
    cd /usr/local/src/$(basename $URL)
    ./configure
    make 
    sudo make install
}

setpermissions()
{
    PERMISSIONS=$(ls -l /usr/local |grep src |awk '{print $1}' | tail -c 4)
    if [ "$PERMISSIONS" = "rwx" ]
    then
        echo All is good for src
    else
        echo permission for src is $PERMISSIONS 
        echo please change it
        echo $1 | sudo -S chmod a+rwx /usr/local/src
    fi

    PERMISSIONS=$(ls -l /usr/local |grep bin |awk '{print $1}' | tail -c 4)
    if [ "$PERMISSIONS" = "rwx" ]
    then
        echo All is good for bin
    else
        echo permission for bin is $PERMISSIONS 
        echo please change it
        echo $1 | sudo -S chmod a+rwx /usr/local/bin
    fi
}

installtar()
{
    URL=$(whiptail --inputbox "" 8 39 --title "Insert the url for the tarball.tar.smth" 3>&1 1>&2 2>&3)
    wget $URL -P /usr/local/src/
    TAR=$(ls -l /usr/local/src --sort=time --reverse | tail --lines 1 | awk '{print $9}')
    tar -xf /usr/local/src/$TAR
    rm /usr/local/src/$TAR
    FOLDER=$(ls -l /usr/local/src/ --sort=time --reverse | tail --lines 1 | awk '{print $9}')
    cd /usr/local/src/$FOLDER
    ./configure
    make 
    echo $1 | sudo -S make install
}

installpkg()
{
    NAME=$(whiptail --inputbox "What do you want to install?" 8 39 --title "Install from package manager" 3>&1 1>&2 2>&3)
    NEMT=$(apt-cache depends $NAME | awk '$1 == "Depends:" {print $2}')
    whiptail --yesno --title "$NAME" "$NAME can be installed and depends on the following packages: \n\n$NEMT\n\n Do you wish to continue?" 25 80
    {
        N=$(echo "$NEMT" | wc -l)
        N=$(($N + 2))
        I=3

        for x in $NEMT; do
            echo "$PASSWORD" | sudo -S apt-get install $x -qq 2> /dev/null
            echo $((100/$N*$I))
            I=$(($I+1))
        done

        echo "$PASSWORD" | sudo -S apt-get install $NAME -qq 2> /dev/null
        echo $((100/$N*$I))
        sleep 1
    } | whiptail --gauge "Please wait while everything is being installed..." 6 70 0
    whiptail --msgbox --title "Finished" "$NAME is sucessfully installed" 25 80
}
