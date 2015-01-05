#!/bin/bash
#colores
rojo="\033[0;31m"
rojoC="\033[1;31m"
verde="\033[0;32m"
verdeC="\033[1;32m"
amarillo="\033[1;33m"
gris="\033[1;30m"
marron="\033[0;33m"
blanco="\033[1;37m"
azulC="\033[1;34m"
resaltar="\E[7m"
colorbase="\E[0m"

function check_flags() {
case $1 in
	--help | -h)
			echo -e "USE: $0 <args>"
			echo -e "\n  ARGS:"
			echo -e "\n    "$blanco"-h:"$colorbase"   \t This help"
			echo -e "\n    "$blanco"-pp:"$colorbase"  \t Password in plain text in screen [ Default ]"
			echo -e "\n    "$blanco"-ph:"$colorbase"  \t Password hidden (no echoed)"
			echo -e "\n    "$blanco"-pa:"$colorbase"  \t Password with asterisk\n"
			exit 1
			;;
	-pp)
			PASS_HIDDEN=NO
			;;
	-ph)
			PASS_HIDDEN=YES
			;;
	-pa)
			PASS_HIDDEN=ASTERISK
			;;
esac
	
}

function check_ifaces() {
CONT=1
IFACES=$(iw dev | awk '/Interface/ { print $2 }' | sort)
IFACES_NUM=$(echo "$IFACES" | wc -l)

#Check available Wifi interfaces
if [ "$IFACES" == "" ]
  then
    echo -e ""$rojo"No available WIFI interfaces !!"$colorbase""
    exit 1
fi

clear
echo -e "\n"$azulC"████████████████████████████████████████████████████████"$colorbase""
echo -e ""$azulC"████ SELECT INTERFACE ██████████████████████████████████"$colorbase"\n"

#Show Interfaces
for i in $IFACES
  do
    local MODE=$(iwgetid -s -m $i)
    if [ "$MODE" != "Managed" ]
      then
        echo -e ""$blanco"$CONT) "$colorbase""$rojoC"$i \t- "$rojo"Interface doesn't support scanning "$resaltar" Mode: $MODE "$colorbase""
        let CONT+=1
    else
      echo -e ""$blanco"$CONT) "$colorbase""$verdeC"$i"$colorbase""
      let CONT+=1
    fi
done

INT="0"
while [ "$INT" -lt "1" -o "$INT" -gt "$IFACES_NUM" ]
  do
    echo -ne "\n\n"$resaltar""$blanco"Select interface:"$colorbase" "
    read INT
    if [ -z $INT ] || [ "$INT" -lt "1" ] || [ "$INT" -gt "$IFACES_NUM" ]
      then
        echo -e ""$rojo" - ERROR - CTRL+C to EXIT"$colorbase""
        sleep .7
        check_ifaces
    fi
done

IFACE_WLAN=$(iw dev | awk '/Interface/ { print $2 }' | sort | head -n $INT | tail -n 1)
ifconfig $IFACE_WLAN up > /dev/null 2>&1
}

function draw() {
local COB=$1
COB=$(echo "$1" | cut -c 2-3 )
if [ "$COB" -le "100" ] && [ "$COB" -gt "90" ]
  then
    SIGNAL=$(echo -ne ""$rojo"▝▀"$gris"▝▀▝▀▝▀▝▀▝▀▝▀▝▀▝▀▝▀"$colorbase"")
  elif [ "$COB" -le "90" ] && [ "$COB" -gt "80" ]
    then
    SIGNAL=$(echo -ne ""$rojo"▝▀▝▀"$gris"▝▀▝▀▝▀▝▀▝▀▝▀▝▀▝▀"$colorbase"")
  elif [ "$COB" -le "80" ] && [ "$COB" -gt "70" ]
    then
    SIGNAL=$(echo -ne ""$rojo"▝▀▝▀"$amarillo"▝▀"$gris"▝▀▝▀▝▀▝▀▝▀▝▀▝▀"$colorbase"")
  elif [ "$COB" -le "70" ] && [ "$COB" -gt "60" ]
    then
    SIGNAL=$(echo -ne ""$rojo"▝▀▝▀"$amarillo"▝▀▝▀"$gris"▝▀▝▀▝▀▝▀▝▀▝▀"$colorbase"")
  elif [ "$COB" -le "60" ] && [ "$COB" -gt "50" ]
    then
    SIGNAL=$(echo -ne ""$rojo"▝▀▝▀"$amarillo"▝▀▝▀"$verde"▝▀"$gris"▝▀▝▀▝▀▝▀▝▀"$colorbase"")
  elif [ "$COB" -le "50" ] && [ "$COB" -gt "40" ]
    then
    SIGNAL=$(echo -ne ""$rojo"▝▀▝▀"$amarillo"▝▀▝▀"$verde"▝▀▝▀"$gris"▝▀▝▀▝▀▝▀"$colorbase"")
  elif [ "$COB" -le "40" ] && [ "$COB" -gt "30" ]
    then
    SIGNAL=$(echo -ne ""$rojo"▝▀▝▀"$amarillo"▝▀▝▀"$verde"▝▀▝▀▝▀"$gris"▝▀▝▀▝▀"$colorbase"")
  elif [ "$COB" -le "30" ] && [ "$COB" -gt "20" ]
    then
    SIGNAL=$(echo -ne ""$rojo"▝▀▝▀"$amarillo"▝▀▝▀"$verde"▝▀▝▀▝▀"$verdeC"▝▀"$gris"▝▀▝▀"$colorbase"")
  elif [ "$COB" -le "20" ] && [ "$COB" -gt "10" ]
    then
    SIGNAL=$(echo -ne ""$rojo"▝▀▝▀"$amarillo"▝▀▝▀"$verde"▝▀▝▀▝▀"$verdeC"▝▀▝▀"$gris"▝▀"$colorbase"")
  elif [ "$COB" -le "10" ] && [ "$COB" -gt "0" ]
    then
    SIGNAL=$(echo -ne ""$rojo"▝▀▝▀"$amarillo"▝▀▝▀"$verde"▝▀▝▀▝▀"$verdeC"▝▀▝▀▝▀"$colorbase"")
fi
}

function discover() {
while [ "$(pidof iw)" != "" ]
  do
    clear
    echo -e "\n"$azulC"█████████████████████████████████████████████████"$colorbase""
    echo -e ""$azulC"████ SCANNING WIFI NETWORKS █████████████████████"$colorbase"\n"
    echo -ne ""$rojo"▝▀▝▀"$colorbase""
    sleep .2
    clear
    echo -e "\n"$azulC"█████████████████████████████████████████████████"$colorbase""
    echo -e ""$azulC"████ SCANNING WIFI NETWORKS █████████████████████"$colorbase"\n"
    echo -ne ""$rojo"▝▀▝▀▝▀▝▀"$colorbase""
    sleep .2
    clear
    echo -e "\n"$azulC"█████████████████████████████████████████████████"$colorbase""
    echo -e ""$azulC"████ SCANNING WIFI NETWORKS █████████████████████"$colorbase"\n"
    echo -ne ""$rojo"▝▀▝▀▝▀▝▀"$amarillo"▝▀▝▀"$colorbase""
    sleep .2
    clear
    echo -e "\n"$azulC"█████████████████████████████████████████████████"$colorbase""
    echo -e ""$azulC"████ SCANNING WIFI NETWORKS █████████████████████"$colorbase"\n"
    echo -ne ""$rojo"▝▀▝▀▝▀▝▀"$amarillo"▝▀▝▀"$verde"▝▀▝▀"$colorbase""
    sleep .2
    clear
    echo -e "\n"$azulC"█████████████████████████████████████████████████"$colorbase""
    echo -e ""$azulC"████ SCANNING WIFI NETWORKS █████████████████████"$colorbase"\n"
    echo -ne ""$rojo"▝▀▝▀▝▀▝▀"$amarillo"▝▀▝▀"$verde"▝▀▝▀▝▀▝▀"$colorbase""
    sleep .2
    clear
    echo -e "\n"$azulC"█████████████████████████████████████████████████"$colorbase""
    echo -e ""$azulC"████ SCANNING WIFI NETWORKS █████████████████████"$colorbase"\n"
    echo -ne ""$rojo"▝▀▝▀▝▀▝▀"$amarillo"▝▀▝▀"$verde"▝▀▝▀"$colorbase""
    sleep .2
    clear
    echo -e "\n"$azulC"█████████████████████████████████████████████████"$colorbase""
    echo -e ""$azulC"████ SCANNING WIFI NETWORKS █████████████████████"$colorbase"\n"
    echo -ne ""$rojo"▝▀▝▀▝▀▝▀"$amarillo"▝▀▝▀"$colorbase""
    sleep .2
    clear
    echo -e "\n"$azulC"█████████████████████████████████████████████████"$colorbase""
    echo -e ""$azulC"████ SCANNING WIFI NETWORKS █████████████████████"$colorbase"\n"
    echo -ne ""$rojo"▝▀▝▀▝▀▝▀"$colorbase""
    sleep .2
done
}

function scan() {
cnt=0
num=1
OLD_IFS=$IFS
IFS=$'\t'
for i in $(iw dev $IFACE_WLAN scan | grep -E 'SSID|signal:' | sed -e 's/signal: //' -e 's/SSID: //' -e 's/dBm//')
  do
    let mod=$cnt%2
    if [ "$mod" == "0" ]
      then
        draw $i
        echo -ne ""$blanco"$num)"$colorbase"\t$SIGNAL\t"
        let num=$num+1
      else
        echo -e "$i"
    fi
    let cnt=$cnt+1
done
IFS=$OLD_IFS
}

function start() {
#Remove empty lines
sed '/^$/d' /tmp/scan_pre.txt > /tmp/scan.txt
rm -r /tmp/scan_pre.txt

MAX_NUM=$(cat /tmp/scan.txt | wc -l)
clear

local OPT=""
while [ -z $OPT ] || [ "$OPT" -lt "1" ] || [ "$OPT" -gt "$MAX_NUM" ]
  do
    clear
    echo -e "\n"$azulC"████████████████████████████████████████████████████████"$colorbase""
    echo -e ""$azulC"██████████ SELECT NETWORK ██████████████████████████████"$colorbase"\n"
    cat /tmp/scan.txt
    echo -e "\n"$blanco"0)\t"$azulC"▝▀▝▀▝▀▝▀▝▀▝▀▝▀▝▀▝▀▝▀\t"$blanco"RESCAN"$colorbase""
    echo -ne "\n\n"$resaltar""$blanco"Network to connect:"$colorbase" "
    read OPT
    if [ -z $OPT ] || [ "$OPT" -lt "0" ] || [ "$OPT" -gt "$MAX_NUM" ]
      then
        echo -e ""$rojo" - ERROR - CTRL+C to EXIT"$colorbase""
        sleep .7
      elif [ "$OPT" -eq "0" ]
        then
          #Function scan and save the results
          scan > /tmp/scan_pre.txt&
          sleep .2
          #Function discover that shows the scan animation
          discover
          sleep .3
          #Function start proccess
          start
    fi
done

#Select network from saved report
NETWORK=$(cat /tmp/scan.txt | head -n $OPT | tail -n 1 | awk '{ $1=$2=""; print $0 }')
NETWORK=$(echo "$NETWORK" | sed -e 's/^[ \t]*//')
echo -e ""$blanco"The net selected is: "$verdeC"$NETWORK"$colorbase""
echo -ne ""$blanco"Password: "$colorbase""
echo -ne ""$rojo""

if [ "$PASS_HIDDEN" == "ASTERISK" ]
  then
	   #Input password hiden
		ASTERISK=""
		echo -ne ""$rojo""
		while IFS= read -p "$ASTERISK" -r -s -n 1 char
		do
			if [[ $char == $'\0' ]]
			then
				break
			fi
			ASTERISK='*'
			PASS+="$char"
		done
   elif [ "$PASS_HIDDEN" == "YES" ]
     then
       read -s PASS
   else		
     read PASS
fi
echo -e ""$colorbase""

#Call wpa_connection to finish the connection
wpa_connection
}

function wpa_connection() {
#Create wpa_supplicant config file
wpa_passphrase "$NETWORK" "$PASS" > "/etc/wpa_supplicant/$NETWORK.conf"

#The connection
iw dev $IFACE_WLAN disconnect > /dev/null 2>&1
killall wpa_supplicant > /dev/null 2>&1
killall NetworkManager > /dev/null 2>&1

wpa_supplicant -B -i $IFACE_WLAN -c "/etc/wpa_supplicant/$NETWORK.conf" -D nl80211
echo -e ""$blanco"+ Kill old dhclient proccess . . ."$colorbase""
killall dhclient > /dev/null 2>&1
sleep 2
timeout 15 dhclient $IFACE_WLAN > /dev/null 2>&1 &
echo -ne ""$blanco"+ Get DHCP request  "$marron""
spinner 25
echo -e ""$colorbase""
ping -I $IFACE_WLAN -c 1 www.google.com > /dev/null 2>&1
if [ "$?" == "0" ]
  then
    echo -e ""$verdeC"\n+ Connection succesful :)"$colorbase"\n"
    exit 0
  else
    echo -e ""$rojo"- ERROR, no internet connection :( "$colorbase"\n"
    echo -e ""$amarillo" POSIBLE REASONS: "$colorbase""
    echo -e ""$amarillo"   - Your wifi password its wrong"$colorbase""
    echo -e ""$amarillo"   - You have to configure manual IP's"$colorbase"\n"
    exit 1
fi
}

function spinner() {
    local time=$1
    local cont=0
    local delay=0.2
    local spinstr='|/-\'
    while [ "$cont" -le "$time" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
	let cont=$cont+1
    done
    printf "    \b\b\b\b"
}


##################
## MAIN program ##
##################
#Check if run as root
if [ "$(id -u)" != "0" ];
  then
    echo "This script must be run as root"
    exit 1
fi

#Check launch options (flags)
check_flags $1
#Function to check available interfaces
check_ifaces
#Function scan and save the results
scan > /tmp/scan_pre.txt&
sleep .2
#Function discover that shows the scan animation
discover
sleep .3
#Function start proccess
start
#Function wpa_connection
wpa_connection

