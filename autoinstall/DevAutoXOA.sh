#! /bin/bash
echo '######################################################'
echo '##                                                  ##'
echo '##                    Auto XOA                      ##'
echo '##                                                  ##'
echo '## Deploy Xen Orchestra from source, automatically. ##'
echo '##                                                  ##'
echo '##              DEVELOPMENT BRANCH                  ##'
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
    MAINSEL=$(whiptail --title "AutoXOA Main Menu" --menu "Choose an option:" 15 60 4 \
		"1" "Install XOA" \
		"2" "Developer Menu" \
		"3" "Start XOA-Server" 3>&1 1>&2 2>&3)

        case $MAINSEL in
            1)
                echo "User selected to install XOA"
                Install
				mainMenu
            ;;
            2)
                echo "User selected developer XOA [Under development]"
                devMenu
            ;; 
			3)
				echo "User selected to start XOA-Server."
				Start_XOAServer
			;;
        esac	
}

function devMenu() {
    DEVSEL=$(whiptail --title "AutoXOA Development Menu" --menu "Choose an option: [Under Development]" 15 60 8 \
		"1" "Update XOA [Under development]" \
        "2" "Change XOA to beta branch [Under development]" \
		"3" "Install Forever [NPM]" \
		"4" "Start Forever XOA-Server" \
		"5" "View Forever Logs" \
		"6" "Stop Forever process" \
		"7" "Other OS Install Menu [Under development]" \
		"8" "Main Menu" 3>&1 1>&2 2>&3)

        case $DEVSEL in
            1)
                echo "User selected to upgrade XOA [Under development]"
                Upgrade
				devMenu
            ;; 
            2)
                echo "User selected to upgrade XOA to a beta branch [Under development]"
                UpgradeBeta
				devMenu
            ;;
            3)
                echo "User selected to install Forever"
                Install_Forever
				Start_Forever	
				devMenu				
            ;;			
			4)
				echo "User selected to start XOA-Server via Forever."
				Start_Forever
				devMenu
			;;
			5)
				echo "User selected to view Forever logs."
				Forever_Logs
				devMenu
			;;
			6)
				echo "User selected to stop XOA-Server via Forever."
				Forever_Stop
				devMenu
			;;
			7)
				echo "User selected to view OS menu."
				OSMenu
			;;
			8)
				echo "User selected to view main menu."
				mainMenu
			;;
			#5)
			#	echo "User selected to install Nodemon"
			#	Install_Nodemon
			#	Start_Nodemon
			#;;
			#6)
			#	echo "User selected to start XOA-Server via Nodemon."
			#	Start_Nodemon
			#;;
        esac
		#devMenu #return to main menu
}

function OSMenu() {
	OSSEL=$(whiptail --title "AutoXOA OS Menu" --menu "Choose an option: [Under Development]" 15 60 4 \
		"1" "Install Fedora XOA [Under development]" \
		"1" "Install OpenSUSE XOA [Under development]" \
		"3" "Install Ubuntu XOA [Under development]" \
		"4" "Main Menu" 3>&1 1>&2 2>&3)

        case $OSSEL in
            1)
                echo "User selected to in stall Dev_Fedora XOA [Under development]"
				Dev_Fedora
            ;;
            2)
                echo "User selected to in stall Dev_SUSE XOA [Under development]"
				Dev_SUSE
            ;; 
            3)
                echo "User selected to in stall Dev_Ubuntu XOA [Under development]"
				Dev_Ubuntu
            ;; 			
			4)
				echo "User selected to view main menu."
				mainMenu
			;;
			#5)
			#	echo "User selected to install Nodemon"
			#	Install_Nodemon
			#	Start_Nodemon
			#;;
			#6)
			#	echo "User selected to start XOA-Server via Nodemon."
			#	Start_Nodemon
			#;;
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
			mainMenu
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


function Install_Forever () {
	echo "Starting Forever install."
	echo "Command: npm install -g forever"
	$SUDO npm install -g forever
}

function Start_Forever () {
	$SUDO forever stop 0 #stop to prevent duplicate instances
	echo "IP Configuration"
	$SUDO ip a
	echo "Starting Forever server."
	$SUDO forever start -c "npm start" /xoa/xo-server/
}

function Forever_Logs () {
	echo "Viewing Forever logs."
	$SUDO forever logs 0
}

function Forever_Stop () {
	echo "Stopping Forever server."
	$SUDO forever stop 0
}

#functionality may be removed

function Install_Nodemon () {
	echo "Starting Nodemon install."
	echo "Command: npm install -g nodemon"
	$SUDO npm install -g nodemon
}

function Start_Nodemon () {
	echo "Starting Nodemon [under develpment]."
	$SUDO cd /xoa/xo-server
	$SUDO nodemon npm start
}

function Dev_Fedora () {
	echo "Starting Fedora Install]."
	Fedora_Initial_Updates
	 Fedora_Install_XOA-server 
	 Fedora_Install_XOA-web
}

function Fedora_Initial_Updates() {
	echo "Installing updates"
   # $SUDO zypper update -y
	echo "Installing dependencies"
	echo "Command: curl + n stable"
	$SUDO curl -o /usr/local/bin/n https://raw.githubusercontent.com/visionmedia/n/master/bin/n
	$SUDO chmod +x /usr/local/bin/n
	$SUDO n stable
	echo "Command: apt-get --yes --force-yes install build-essential redis-server libpng-dev git python-minimal"
	$SUDO zypper install -y build-essential redis-server libpng-dev git python-minimal
	echo "Command: npm install -g bower"
	$SUDO npm install -g bower	#Needed for XOA-Web only
}

function Fedora_Install_XOA-server () {
	$SUDO cd /xoa
	echo "Command: git clone -b stable http://github.com/vatesfr/xo-server"
	$SUDO git clone -b stable http://github.com/vatesfr/xo-server
	$SUDO cd xo-server
	echo "Command: npm install"
	$SUDO npm install 
	echo "Command: npm run build"
	$SUDO npm run build	
	echo "Command: curl -L https://raw.githubusercontent.com/hackmods/autoXOA/config/autoinstall/xo-server.yaml > .xo-server.yaml"
	$SUDO curl -L https://raw.githubusercontent.com/hackmods/autoXOA/master/config/xo-server.yaml > .xo-server.yaml
	$SUDO cd ..
}

function Fedora_Install_XOA-web () {
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


function Dev_SUSE () {
	echo "Starting OpenSUSE Install]."
	 SUSE_Initial_Updates
	 SUSE_Install_XOA-server 
	 SUSE_Install_XOA-web
}

function SUSE_Initial_Updates() {
	echo "Installing updates"
    $SUDO zypper update -y
	echo "Installing dependencies"
	echo "Command: curl + n stable"
	$SUDO curl -o /usr/local/bin/n https://raw.githubusercontent.com/visionmedia/n/master/bin/n
	$SUDO chmod +x /usr/local/bin/n
	$SUDO n stable
	echo "Command: apt-get --yes --force-yes install build-essential redis-server libpng-dev git python-minimal"
	$SUDO zypper install -y build-essential redis-server libpng-dev git python-minimal
	echo "Command: npm install -g bower"
	$SUDO npm install -g bower	#Needed for XOA-Web only
}

function SUSE_Install_XOA-server () {
	$SUDO cd /xoa
	echo "Command: git clone -b stable http://github.com/vatesfr/xo-server"
	$SUDO git clone -b stable http://github.com/vatesfr/xo-server
	$SUDO cd xo-server
	echo "Command: npm install"
	$SUDO npm install 
	echo "Command: npm run build"
	$SUDO npm run build	
	echo "Command:  curl -L https://raw.githubusercontent.com/hackmods/autoXOA/master/config/xo-server.yaml > .xo-server.yaml"
	$SUDO curl -L https://raw.githubusercontent.com/hackmods/autoXOA/master/config/xo-server.yaml > .xo-server.yaml
	$SUDO cd ..
}

function SUSE_Install_XOA-web () {
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


function Dev_Ubuntu () {
	echo "Starting Ubuntu Install]."
	Ubuntu_Initial_Updates
	Ubuntu_Install_XOA-server
	Ubuntu_Install_XOA-web
}


function Ubuntu_Initial_Updates() {
	echo "Installing updates"
   # $SUDO zypper update -y
	echo "Installing dependencies"
	echo "Command: curl + n stable"
	$SUDO curl -o /usr/local/bin/n https://raw.githubusercontent.com/visionmedia/n/master/bin/n
	$SUDO chmod +x /usr/local/bin/n
	$SUDO n stable
	echo "Command: apt-get --yes --force-yes install build-essential redis-server libpng-dev git python-minimal"
	$SUDO zypper install -y build-essential redis-server libpng-dev git python-minimal
	echo "Command: npm install -g bower"
	$SUDO npm install -g bower	#Needed for XOA-Web only
}

function Ubuntu_Install_XOA-server () {
	$SUDO cd /xoa
	echo "Command: git clone -b stable http://github.com/vatesfr/xo-server"
	$SUDO git clone -b stable http://github.com/vatesfr/xo-server
	$SUDO cd xo-server
	echo "Command: npm install"
	$SUDO npm install 
	echo "Command: npm run build"
	$SUDO npm run build	
	echo "Command: curl -L 	https://raw.githubusercontent.com/hackmods/autoXOA/master/config/xo-server.yaml > .xo-server.yaml"
	$SUDO curl -L https://raw.githubusercontent.com/hackmods/autoXOA/master/config/xo-server.yaml > .xo-server.yaml
	$SUDO cd ..
}

function Ubuntu_Install_XOA-web () {
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

#internetCheck
#verifyFreeDiskSpace
mainMenu
echo "Thank you for using AutoXOA. Leave feedback at zxcv.us or contribute to the Github project."