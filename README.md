# GoIP status
Get the status of 1 port GoIP

I made this script for a Zabbix check. It is quick-and-dirty, but it works perfectly.

Usage is simpel.

1. Download the get.sh script
2. Check the values on top of the bash script (explained below)
4. Make it executable (chmod +x get.sh)
5. And run it! (./get.sh)
6. When you run it without any commandline options, you will see all values


Values;

GOIP_IP = IP address of you GoIP device
GOIP_USER = Username which you use to login to your GoIP device
GOIP_PASS = You guested it! The password which you use to login to your GoIP device

Optional you can set the CACHE value higher/lower. If you request the values within x seconds, it will pull the values out of its cache instead of requesting it again. By default I have put it on 20 seconds.

Commandline options;

	--lac           Get the GSM LAC
	--cell          Get the GSM Cell ID 
	--signal        Get the signal strength
	--operator      Get the operator
	--imei          Display the IMEI of the sim
	--status        Overall status (when everything is fine it returns OK otherwise NOK)
	--statussim     Displays status of the SIM (Y/N)
	--statusgsm     Displays status of GSM network (Y/N)
	--statusvoip    Displays status VoIP (Y/N)
  
  Options can not be combined.
