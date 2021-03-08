CHOICE=$(
whiptail --title "Installation" --menu "This is not printed" 16 100 9 \
	"1)" "Install from github" \
	"2)" "Install from tarball" \
	"3)" "Install from deb" \
	"4)" "Install from package manager" \
	"5)" "Exit" \
    3>&2 2>&1 1>&3	
)

