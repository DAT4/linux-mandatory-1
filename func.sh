installtar()
{
    DIR=$(download TAR)
    tar -xf $DIR -C /usr/local/src/ > /dev/null
    rm $DIR
    FOLDER=$(ls -l /usr/local/src/ --sort=time | tail --lines 1 | awk '{print $9}')
    cd /usr/local/src/$FOLDER
    ./configure
    make
    echo $1 | sudo -S make install
}

installpkg()
{
    NAME=$(whiptail --inputbox "What do you want to install?" 8 39 --title "Install from package manager" 3>&1 1>&2 2>&3)
    NEMT=$(apt-cache depends $NAME | awk '$1 == "Depends:" {print $2}')
    dependencies $NAME "$1 | sudo -S dpkg -i $DIR -qq 2> /dev/null)"
}

installgit()
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
    if [ "$PERMISSIONS" != "rwx" ]
    then
        echo $1 | sudo -S chmod a+rwx /usr/local/src
    fi

    PERMISSIONS=$(ls -l /usr/local |grep bin |awk '{print $1}' | tail -c 4)
    if [ "$PERMISSIONS" != "rwx" ]
    then
        echo $1 | sudo -S chmod a+rwx /usr/local/bin
    fi
}

download()
{
    URL=$(whiptail --inputbox "Input the url for the $1 file you want to install." 8 39 --title "$1 INSTALLATION" 3>&1 1>&2 2>&3)
    (cd /usr/local/src/ && curl -s -O $URL)
    echo /usr/local/src/$(ls -l /usr/local/src --sort=time | tail --lines 1 | awk '{print $9}')
}

dependencies()
{
    NEMT=$(apt-cache depends $1 | awk '$1 == "Depends:" {print $2}')
    if $(whiptail --yesno --title "$1" "$1 can be installed and depends on the following packages: \n\n$NEMT\n\n Do you wish to continue?" 25 80 3>&1 1>&2 2>&3)
    then
        {
            N=$(echo "$NEMT" | wc -l)
            N=$(($N + 2))
            I=3

            for x in $NEMT; do
                echo "$1" | sudo -S apt-get install $x -qq 2> /dev/null
                echo $((100/$N*$I))
                I=$(($I+1))
            done

            eval $2
            echo $((100/$N*$I))
            sleep 1
        } | whiptail --gauge "Please wait while everything is being installed..." 6 70 0
        whiptail --msgbox --title "Finished" "$1 is sucessfully installed" 25 80
    else
        whiptail --msgbox --title "Canelled" "You didnt want to install the dependencies" 25 80
    fi
}

installdeb()
{
    DIR=$(download DEB)
    NAME=$(dpkg -I $DIR |grep Package: | cut -d ":" -f 2)
    rm $DIR
    dependencies $NAME "$1 | sudo -S dpkg -i $DIR -qq 2> /dev/null)"
}
