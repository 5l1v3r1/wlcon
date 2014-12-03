#!/bin/bash
#colores
rojo="\033[1;31m"
verde="\033[0;32m"
verdeC="\033[1;32m"
amarillo="\033[1;33m"
gris="\033[1;30m"
blanco="\033[1;37m"
azulC="\033[1;34m"
resaltar="\E[7m"
colorbase="\E[0m"

#IFACE=wlan2

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
echo -e "\n"$azulC"█████████████████████████████████████████████████"$colorbase""
echo -e ""$azulC"████ SELECT INTERFACE ███████████████████████████"$colorbase"\n"

#Show Interfaces
for i in $IFACES
  do
    echo -e ""$blanco"$CONT) "$colorbase"$i"
    let CONT+=1
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
#Function scan and save the results
scan > /tmp/scan_pre.txt&

sleep .2
#Function discover that shows the scan animation
discover

sleep .3

#Remove empty lines
sed '/^$/d' /tmp/scan_pre.txt > /tmp/scan.txt
rm -r /tmp/scan_pre.txt

MAX_NUM=$(cat /tmp/scan.txt | wc -l)
clear

OPT=0
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
      elif [ "$OPT" == "0" ]
        then
          start
    fi
done
}

## MAIN program ##
#Check if run as root
if [ "$(id -u)" != "0" ];
  then
    echo "This script must be run as root"
    exit 1
fi


check_ifaces

start

#Select network from saved report
NETWORK=$(cat /tmp/scan.txt | head -n $OPT | tail -n 1 | awk '{ $1=$2=""; print $0 }')
NETWORK=$(echo "$NETWORK" | sed -e 's/^[ \t]*//')
echo -e ""$blanco"The net selected is: "$verdeC"$NETWORK"$colorbase""
echo -ne ""$blanco"Password: "$colorbase""

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
echo -e ""$colorbase""

#Create wpa_supplicant config file
wpa_passphrase "$NETWORK" "$PASS" > "/etc/wpa_supplicant/$NETWORK.conf"

#The connection
iw dev $IFACE_WLAN disconnect > /dev/null 2>&1
killall wpa_supplicant > /dev/null 2>&1
killall NetworkManager > /dev/null 2>&1

wpa_supplicant -B -i $IFACE_WLAN -c "/etc/wpa_supplicant/$NETWORK.conf" -D nl80211
echo -e ""$blanco"+ Trying to connect . . ."$colorbase""
sleep 2
timeout 15 dhclient $IFACE_WLAN > /dev/null 2>&1
ping -I $IFACE_WLAN -c 1 www.google.com > /dev/null 2>&1
if [ "$?" == "0" ]
  then
    echo -e ""$verdeC"+ Connection succesful :)"$colorbase"\n"
  else
    echo -e ""$rojo"- ERROR, no internet connection :( "$colorbase"\n"
    echo -e ""$amarillo" POSIBLE REASONS: "$colorbase""
    echo -e ""$amarillo"   - Your wifi password its wrong"$colorbase""
    echo -e ""$amarillo"   - You have to configure manual IP's"$colorbase"\n"
fi
