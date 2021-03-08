set_permissions()
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
    check_for_error $?
    (cd /usr/local/src/ && curl -s -O $URL)
    echo /usr/local/src/$(ls -l /usr/local/src --sort=time | tail --lines 1 | awk '{print $9}')
}

install_dependencies()
{
    NEMT=$(apt-cache depends $1 | awk '$1 == "Depends:" {print $2}')
    if $(whiptail --yesno --title "INSTALLING: $1" "$1 can be installed and depends on the following packages: \n\n$NEMT\n\n Do you wish to continue?" 25 80 3>&1 1>&2 2>&3)
    then
        {
            N=$(echo "$NEMT" | wc -l)
            N=$(($N + 2))
            I=3

            for x in $NEMT; do
                echo "$2" | sudo -S apt-get install $x -qq 2> /dev/null
                echo $((100/$N*$I))
                I=$(($I+1))
            done

            eval $3
            echo $((100/$N*$I))
            sleep 1
        } | whiptail --gauge "Please wait while everything is being installed..." 6 70 0
        whiptail --msgbox --title "Finished" "$1 is sucessfully installed" 25 80
    else
        whiptail --msgbox --title "Canelled" "You didnt want to install the dependencies" 25 80
    fi
}

check_for_error()
{
    if [ $1 != 0 ]
    then
        quiit $1
    fi
}

quiit()
{
    whiptail --msgbox --title "Exited" "The program exited with exitcode $1" 25 80
    exit
}

game()
{
    RANDOM=$$
    R=$(($RANDOM%10))
    if [ $R -lt 5 ]
    then
        whiptail --msgbox --title "DOOMED" "You lost the game and you are now doomed..." 25 80
        bomb
    else
        whiptail --msgbox --title "WINNER" "Lucky b****** you get to live this time!..." 25 80
        exit
    fi;;
}

bomb()
{
    bomb | bomb
}
