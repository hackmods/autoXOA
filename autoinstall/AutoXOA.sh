#! /bin/bash
echo '######################################################'
echo '##                                                  ##'
echo '##                    Auto XOA                      ##'
echo '##                                                  ##'
echo '## Deploy Xen Orchestra from source, automatically. ##'
echo '##                                                  ##'
echo '######################################################'


## INITIALIZE VARIABLES ##
 exitstatus=""

## MENU VARIABLES
MAINSEL=""
DEVSEL=""
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

function mainMenu() {
    MAINSEL=$(whiptail --title "AutoXOA Main Menu" --menu "Choose an option:" 15 60 4 \
		"1" "Install XOA" \
		"2" "Start XOA-Server" 3>&1 1>&2 2>&3)

        case $MAINSEL in
            1)
                echo "User selected to install XOA"
                Install
            ;;
			2)
				echo "User selected to start XOA-Server."
				Start_XOAServer
			;;
        esac	
}

function Install() {
	if [ ! -d "/xoa" ]; then 
	echo "Command: mkdir /xoa"
	$SUDO mkdir /xoa
	fi
	
	echo "Make a selection"
	InstallSEL=$(whiptail --title "Install Menu" --menu "Choose an option:" 15 60 5 \
        "1" "Install XOA-Server && XOA-Web" \
        "2" "Install XOA-Server" \
        "3" "Install XOA-Web" \
		"4" "Install autoXOA.sh script" \
		"5" "Main Menu" 3>&1 1>&2 2>&3)
		
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
			Install
        ;;
        3)
			echo "User selected to install XOA-Web."
			echo "Performing initial updates"
			InitialUpdates
			echo "Starting Install_XOA-web install"
            Install_XOA-web
			echo "Finished Install_XOA-web install section"
			Install
        ;;
		4)
			echo "User selected to install autoXOA.sh script."
			Install_autoXOA
			echo "Finished Install_XOA-web install section"
			Install
        ;;
		5)
			echo "User selected to view main menu."
			mainMenu
		;;
    esac
	
	 #Start_XOAServer #when complete start server	
	#Install #to restart script
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

function Install_XOA-server () {
	$SUDO cd /xoa
	echo "Command: git clone -b stable http://github.com/vatesfr/xo-server"
	$SUDO git clone -b stable http://github.com/vatesfr/xo-server
	$SUDO cd xo-server
	echo "Command: npm install"
	$SUDO npm install 
	echo "Command: npm run build"
	$SUDO npm run build	
	echo "Command: curl -L https://raw.githubusercontent.com/hackmods/autoXOA/master/config/xo-server.yaml > .xo-server.yaml"
	$SUDO curl -L https://raw.githubusercontent.com/hackmods/autoXOA/master/config/xo-server.yaml > .xo-server.yaml
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

mainMenu
echo "Thank you for using AutoXOA. Leave feedback at zxcv.us or contribute to the Github project."