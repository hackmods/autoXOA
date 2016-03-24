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
	"2" "Update XOA" \
        "3" "Change XOA to beta branch"  3>&1 1>&2 2>&3)

        case $MAINSEL in

            1)
                echo "User selected to install XOA"
                Install
            ;;
            2)
                echo "User selected to upgrade XOA"
                Upgrade
            ;; 
            3)
                echo "User selected to upgrade XOA to a beta branch"
                UpgradeBeta
            ;; 
        esac
}


function advancedMenu() {
    ADVSEL=$(whiptail --title "Advanced Menu" --menu "Choose an option" 15 60 4 \
        "1" "Choose Packages to Install" \
        "2" "Configure Services" \
        "3" "Back" 3>&1 1>&2 2>&3)
    case $ADVSEL in
        1)
            echo "User selected Package install."
            Install
        ;;
        2)
            echo "User selected Configure Services."
            Upgrade
        ;;
        3)
            UpgradeBeta
        ;;
    esac
}

function Install() {
    $SUDO apt-get update && $SUDO apt-get upgrade -y
	$SUDO curl -o /usr/local/bin/n https://raw.githubusercontent.com/visionmedia/n/master/bin/n
	$SUDO chmod +x /usr/local/bin/n
	$SUDO n stable
	$SUDO apt-get --yes --force-yes install build-essential redis-server libpng-dev git python-minimal
	$SUDO mkdir /xoa
	$SUDO cd /xoa
	$SUDO git clone -b stable http://github.com/vatesfr/xo-server
	$SUDO git clone -b stable http://github.com/vatesfr/xo-web
	$SUDO cd xo-server
	$SUDO npm install && npm run build	
	$SUDO cd ..
	$SUDO cd xo-web
	$SUDO npm install
	$SUDO npm install -g bower	
	$SUDO npm run build

	$SUDO cd ..
	$SUDO cd xo-server
	$SUDO npm start
}

function Upgrade() {
	echo "In development."
	$SUDO cd /xoa
	$SUDO git pull --ff-only
	$SUDO cd xo-server
	$ npm install
	$ npm run build
}

function UpgradeBeta() {
	echo "In development."
	$SUDO cd /xoa
	$SUDO git checkout next-release
}

internetCheck
verifyFreeDiskSpace
mainMenu
