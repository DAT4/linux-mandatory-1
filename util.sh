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
    (cd /usr/local/src/ && curl -s -O $URL)
    echo /usr/local/src/$(ls -l /usr/local/src --sort=time | tail --lines 1 | awk '{print $9}')
}

install_dependencies()
{
    echo "ONE: $1" #NAME
    echo "TWO: $2" #PASSWORD
    echo "TRE: $3" #COMMAND

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
