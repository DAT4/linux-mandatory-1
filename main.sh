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
    echo "nothing."
fi

whiptail --msgbox --title "Goodbye" $URL 25 80

#
#NAME=$(whiptail --inputbox "What is your name?" 8 39 --title "Getting to know you" 3>&1 1>&2 2>&3)
#
#
#
#whiptail --msgbox --title "Goodbye" $RETURN 25 80

