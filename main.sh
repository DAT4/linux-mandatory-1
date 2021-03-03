. ./func.sh

whiptail --msgbox --title "Welcome" "Welcome to this installer program\n click ok to continue..." 25 80

if (whiptail --title "Pick option!" --yesno "Do you want to install something from souce?" 8 78); then
    RETURN=true
else
    RETURN=false
fi


if $RETURN; then
    URL=$(whiptail --inputbox "" 8 39 --title "Insert the url" 3>&1 1>&2 2>&3)
    gitinstall $URL
else
    NAME=$(whiptail --inputbox "What do you want to install?" 8 39 --title "Install from package manager" 3>&1 1>&2 2>&3)



    PASSWORD=$(whiptail --passwordbox "Get sudo with password" 8 39 newpdk1234 --title "Sudo" 3>&1 1>&2 2>&3)

    NEMT=$(apt-cache depends $NAME | awk '$1 == "Depends:" {print $2}')

    whiptail --yesno --title "$NAME" "$NAME can be installed and depends on the following packages: \n\n$NEMT\n\n Do you wish to continue?" 25 80

    {
        N=$(echo "$NEMT" | wc -l)
        N=$(($N + 2))
        I=3

        for x in $NEMT; do
            echo "$PASSWORD" | sudo -S apt install $x -qq 2> /dev/null
            echo $((100/$N*$I))
            I=$(($I+1))
        done

        echo "$PASSWORD" | sudo -S apt-get install $NAME -qq 2> /dev/null
        echo $((100/$N*$I))
        sleep 1

    } | whiptail --gauge "Please wait while everything is being installed..." 6 50 0
    
    whiptail --msgbox --title "Finished" "$NAME is sucessfully installed" 25 80
fi

