. ./func.sh

whiptail --msgbox --title "Welcome" "Welcome to this installer program\n click ok to continue..." 25 80

PASSWORD=$(whiptail --passwordbox "Get sudo with password" 8 39 --title "Sudo" 3>&1 1>&2 2>&3)

setpermissions $PASSWORD

CHOICE=$(
whiptail --title "Installation" --menu "This is not printed" 16 100 9 \
	"1)" "Install from github" \
	"2)" "Install from tarball" \
	"3)" "Install from deb" \
	"4)" "Install from package manager" \
	"5)" "Exit" \
    3>&2 2>&1 1>&3	
)

case $CHOICE in
	"1)")
        gitinstall $URL
	;;
	"2)")
        installtar $PASSWORD
	;;

	"3)")
        whiptail --msgbox --title "Install from deb" "This is not implemented..." 25 80
    ;;

	"4)")
        installpkg $PASSWORD
    ;;

	"5)") 
        exit
    ;;
esac
