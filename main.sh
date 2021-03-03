. ./func.sh

PASSWORD=$(whiptail --passwordbox "Get sudo with password" 8 39 --title "Sudo" 3>&1 1>&2 2>&3)

#PERMISSION PART IS DONE STEP 10
PERMISSIONS=$(ls -l /usr/local |grep src |awk '{print $1}' | tail -c 4)
if [ "$PERMISSIONS" = "rwx" ]
then
    echo All is good for src
else
    echo permission for src is $PERMISSIONS 
    echo please change it
    echo $PASSWORD | sudo -S chmod a+rwx /usr/local/src
fi

PERMISSIONS=$(ls -l /usr/local |grep bin |awk '{print $1}' | tail -c 4)
if [ "$PERMISSIONS" = "rwx" ]
then
    echo All is good for bin
else
    echo permission for bin is $PERMISSIONS 
    echo please change it
    echo $PASSWORD | sudo -S chmod a+rwx /usr/local/bin
fi




# STEP 1 INFORM THE USER THAT WE WILL INSTALL SOM STUFF
whiptail --msgbox --title "Welcome" "Welcome to this installer program\n click ok to continue..." 25 80

if (whiptail --title "Pick option!" --yesno "Do you want to install something from souce?" 8 78); then
    RETURN=true
else
    RETURN=false
fi


if $RETURN; then
    #INSTALLING FROM SOURCE
    if (whiptail --title "Git or Tarball!" --yesno "If you want to install from git click yes, if you want to instal from a tarball click no." 8 78)
    then
        URL=$(whiptail --inputbox "" 8 39 --title "Insert the url for the github repo" 3>&1 1>&2 2>&3)
        gitinstall $URL
    else
        URL=$(whiptail --inputbox "" 8 39 --title "Insert the url for the tarball.tar.smth" 3>&1 1>&2 2>&3)
        wget $URL -P /usr/local/src/
        TAR=$(ls -l /usr/local/src --sort=time --reverse | tail --lines 1 | awk '{print $9}')
        tar -xf /usr/local/src/$TAR
        rm /usr/local/src/$TAR
        FOLDER=$(ls -l /usr/local/src/ --sort=time --reverse | tail --lines 1 | awk '{print $9}')
        cd /usr/local/src/$FOLDER
        ./configure
        make 
        echo $PASSWORD | sudo -S make install
    fi
else
    #INSTALLING FROM PACKAGE
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

    } | whiptail --gauge "Please wait while everything is being installed..." 6 50 0
    
    whiptail --msgbox --title "Finished" "$NAME is sucessfully installed" 25 80
fi

