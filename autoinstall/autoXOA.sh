#! /bin/bash
echo '########################################################'
echo '##                                                    ##'
echo '##                     Auto XOA                       ##'
echo '##                                                    ##'
echo '##  Deploy Xen Orchestra from source, automatically.  ##'
echo '##                                                    ##'
echo '########################################################'


## INITIALIZE VARIABLES ##
 exitstatus=""

## MENU VARIABLES
 MAINSEL=""
 PKGSEL=""
 ADVSEL=""
InstallSEL=""

## ROOT CHECK ## 
# Are we root? If not use sudo
if [[ $EUID -eq 0 ]];then
    echo "You are root."
else
    echo "Sudo will be used for the install."
    # Check if it is actually installed
    # If it isn't, exit because the install cannot complete
    if [[ $(dpkg-query -s sudo) ]];then
        export SUDO="sudo"
    else
        echo "Please install sudo or run this as root."
        exit 1
    fi
fi

## FUNCTIONS ##

    ## INTERNET CHECK##
function internetCheck() {
    wget -q --spider http://google.com

    if [ $? -eq 0 ]; then
        echo "Okay we are connected to the Internet. Let's proceed."
    else
        echo "Plase connect to the Internet and try running again."
        exit 1
    fi
    ## CHECK FREE DISK SPACE ##
}

function verifyFreeDiskSpace() {
    # Figure out minimum space required. Currently set at 1GB
    requiredFreeBytes=1000000
    existingFreeBytes=`df -lkP / | awk '{print $4}' | tail -1`

    if [[ $existingFreeBytes -lt $requiredFreeBytes ]]; then
        whiptail --msgbox --backtitle "Insufficient Disk Space" --title "Insufficient Disk Space" "\nYour system appears to be low on disk space. Informeshion recomends a minimum of $requiredFreeBytes Bytes.\nYou only have $existingFreeBytes Free.\n\nI"
        exit 1
    fi
}

function mainMenu() {
    MAINSEL=$(whiptail --title "AutoXOA Main Menu" --menu "Choose a task" 15 60 4 \
        "1" "Install XOA" \
		"2" "Update XOA [Under development]" \
        "3" "Change XOA to beta branch [Under development]" \
		"4" "Start XOA-Server" 3>&1 1>&2 2>&3)

        case $MAINSEL in

            1)
                echo "User selected to install XOA"
                Install
            ;;
            2)
                echo "User selected to upgrade XOA [Under development]"
                Upgrade
            ;; 
            3)
                echo "User selected to upgrade XOA to a beta branch [Under development]"
                UpgradeBeta
            ;; 
			4)
				echo "User selected to start XOA-Server."
				Start_XOAServer
			;;
        esac
		echo "Thank you for using AutoXOA."
}

function Install() {
	if [ ! -d "/xoa" ]; then 
	echo "Command: mkdir /xoa"
	$SUDO mkdir /xoa
	fi
	
	echo "Make a selection"
	InstallSEL=$(whiptail --title "Install Menu" --menu "Choose an option" 15 60 4 \
        "1" "Install XOA-Server && XOA-Web" \
        "2" "Install XOA-Server" \
        "3" "Install XOA-Web" \
		"4" "Install autoXOA.sh script" \
		"5" "Return to main menu" 3>&1 1>&2 2>&3)
		
    case $InstallSEL in
        1)
            echo "User selected to install XOA-Server && XOA-Web."
			echo "Performing initial updates"
			InitialUpdates
			echo "Starting Install_XOA-server install"
            Install_XOA-server
			echo "Starting Install_XOA-web install"
			Install_XOA-web
			echo "Starting autoXOA install"
			Install_autoXOA
			echo "All installations have been completed."
			Start_XOAServer
        ;;
        2)
            echo "User selected to install XOA-Server."
			echo "Performing initial updates"
			InitialUpdates
			echo "Starting Install_XOA-server install"
            Install_XOA-server
			echo "Finished Install_XOA-server install section"
        ;;
        3)
			echo "User selected to install XOA-Web."
			echo "Performing initial updates"
			InitialUpdates
			echo "Starting Install_XOA-web install"
            Install_XOA-web
			echo "Finished Install_XOA-web install section"
        ;;
		4)
			echo "User selected to install autoXOA.sh script."
			Install_autoXOA
			echo "Finished Install_XOA-web install section"
        ;;
    esac
	
	 #Start_XOAServer #when complete start server	
	mainMenu #to restart script
}

function InitialUpdates() {
	echo "Installing updates"
    $SUDO apt-get update && $SUDO apt-get upgrade -y
	
	echo "Installing dependencies"
	echo "Command: curl + n stable"
	$SUDO curl -o /usr/local/bin/n https://raw.githubusercontent.com/visionmedia/n/master/bin/n
	$SUDO chmod +x /usr/local/bin/n
	$SUDO n stable
	echo "Command: apt-get --yes --force-yes install build-essential redis-server libpng-dev git python-minimal"
	$SUDO apt-get --yes --force-yes install build-essential redis-server libpng-dev git python-minimal
	echo "Command: npm install -g bower"
	$SUDO npm install -g bower	#Needed for XOA-Web only
}

function Upgrade() {
	echo "In development. Attempting upgrade to Xo-Server"
	$SUDO cd /xoa
	echo "Current Dir"
	pwd
	echo "Command: git pull"
	$SUDO git pull --ff-only http://github.com/vatesfr/xo-server
	$SUDO cd xo-server
	echo "Command: npm install"
	$ npm install
	echo "Command: npm run build"
	$ npm run build
	$SUDO cd ..
	echo "Attempting upgrade to Xo-Web"
	echo "Command: git pull"
	$SUDO git pull --ff-only http://github.com/vatesfr/xo-web
	$SUDO cd xo-web
	echo "Command: npm install"
	$ npm install
	echo "Command: npm run build"
	$ npm run build
	
}

function UpgradeBeta() {
	echo "In development. Attempting upgrade to next-release"
	$SUDO cd /xoa
	echo "Command: git checkout next-release"
	$SUDO git checkout next-release
	echo "Command: npm install"
	$ npm install
	echo "Command: npm run build"
	$ npm run build
}

function Install_XOA-server () {
	$SUDO cd /xoa
	echo "Command: git clone -b stable http://github.com/vatesfr/xo-server"
	$SUDO git clone -b stable http://github.com/vatesfr/xo-server
	$SUDO cd xo-server
	echo "Command: npm install"
	$SUDO npm install 
	echo "Command: npm run build"
	$SUDO npm run build	
	echo "Command: curl -L https://raw.githubusercontent.com/hackmods/autoXOA/master/autoinstall/xo-server.yaml > .xo-server.yaml"
	$SUDO curl -L https://raw.githubusercontent.com/hackmods/autoXOA/master/autoinstall/xo-server.yaml > .xo-server.yaml
	$SUDO cd ..
}

function Install_XOA-web () {
	$SUDO cd /xoa
	echo "Command: git clone -b stable http://github.com/vatesfr/xo-web"
	$SUDO git clone -b stable http://github.com/vatesfr/xo-web
	$SUDO cd xo-web
	echo "Command: npm install"
	$SUDO npm install
	echo "Command: npm run build	"
	$SUDO npm run build	
	$SUDO cd ..
}

function Install_autoXOA () {
	$SUDO cd /xoa
	echo "Command: curl -L autoxoa.zxcv.us > autoXOA.sh"
	$SUDO curl -L autoxoa.zxcv.us > autoXOA.sh
	$SUDO chmod +x autoXOA.sh
	$SUDO cd ..
}

function Start_XOAServer () {
	#ip = $($SUDO ip a)
	#echo "IP Configuration \n $ip \n Click Okay to start XOA-Server." > test_textbox
	#                  filename height width
	#whiptail --textbox test_textbox 12 80
	#whiptail --title "Example Dialog" --msgbox "IP Configuration \n $ip \n Click Okay to start XOA-Server." 3>&1 1>&2 2>&3
	echo "IP Configuration"
	$SUDO ip a
	echo " "
	$SUDO cd /xoa/xo-server
	echo "Starting xo-server"
	$SUDO npm start
}

function SetDir () {

user_name=/xoa/user_name.txt

whiptail --backtitle "A Simple User Interface" \
         --inputbox "User Name:" 10 20 \
         2> "$user_name"

if [ $? = 0 ]; then
    echo "The user name is "`cat "$user_name"`
else
    rm -f "$user_name"
    echo "Canceled."
fi
}
#internetCheck
#verifyFreeDiskSpace
mainMenu
