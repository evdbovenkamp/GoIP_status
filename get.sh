#!/bin/bash

# Created by Erwin van den Bovenkamp - 2021
# Use with 1-port GoIP

COMMAND=$1

# User variables
GOIP_IP="192.168.178.90"
GOIP_USER="admin"
GOIP_PASS="admin"
CACHE=20


REQUIREMENTS() {

require=( html2text )

for i in "${require[@]}"
do
   which $i >/dev/null 2>&1 || { echo "Error! $i not installed"; exit 1; }
done

ping -c1 -w1 $GOIP_IP 2>&1 >/dev/null || { echo "GoIP is not available on $GOIP_IP"; exit 1; }

}


GET() {

# Do not pull new values when last values are within x seconds.
AGE=$(date -r /tmp/goip.tmp +%s)
NOW=$(date +%s)
[ $(expr $NOW - $AGE) -lt $CACHE ] && { return; }

URL="http://$GOIP_USER:$GOIP_PASS@$GOIP_IP"
curl -s "$URL/default/en_US/status.html" > /tmp/goip.tmp
curl -s "$URL/default/en_US/status.html?type=gsm" > /tmp/goip_status.tmp

}

PUT() {

LAC=$(cat /tmp/goip_status.tmp | grep -i 'L1_lac' | html2text | cut -d',' -f1 | cut -d':' -f2)
CELL=$(cat /tmp/goip_status.tmp | grep -i 'L1_lac' | html2text | cut -d',' -f2 | cut -d':' -f2)
OPERATOR=$(cat /tmp/goip.tmp | grep -i 'l1_gsm_cur_oper' | html2text )
SIGNAL=$(cat /tmp/goip.tmp | grep -i 'l1_gsm_signal' | html2text )
IMEI=$(cat /tmp/goip_status.tmp | grep -i 'l1_gsm_imei' | html2text)
STATUS_SIM=$(cat /tmp/goip.tmp | grep -i 'l1_gsm_sim' | html2text)
STATUS_GSM=$(cat /tmp/goip.tmp | grep -i 'l1_gsm_status' | html2text)
STATUS_VOIP=$(cat /tmp/goip.tmp | grep -i 'l1_status_line' | html2text)

[ "$STATUS_SIM" == "$STATUS_GSM" -a "$STATUS_SIM" == "Y" -a "$STATUS_VOIP" == "Y" ] && { STATUS="OK"; } || { STATUS="NOK"; }

}

# Check requirements
REQUIREMENTS

# Get the status
GET

# Put values in variables
PUT

case $COMMAND in

	--lac)
		echo "$LAC"
		;;
	--cell)
		echo "$CELL"
		;;
	--signal)
		echo "$SIGNAL"
		;;
	--operator)
		echo "$OPERATOR"
		;;
	--imei)
		echo "$IMEI"
		;;
	--status)
		echo "$STATUS"
		;;
	--statussim)
		echo "$STATUS_SIM"
		;;
	--statusgsm)
		echo "$STATUS_GSM"
		;;
	--statusvoip)
		echo "$STATUS_VOIP"
		;;

	*) 
		echo "LAC:             $LAC"
		echo "CALL:            $CELL"
		echo "OPERATOR:        $OPERATOR"
		echo "SIGNAL:          $SIGNAL"
		echo "IMEI:            $IMEI" 
		echo "STATUS:          $STATUS"
		echo "SIM ACTIVE:      $STATUS_SIM"
		echo "GSM REGISTERED:  $STATUS_GSM"
		echo "VOIP REGISTERED: $STATUS_VOIP"
		;;
esac
