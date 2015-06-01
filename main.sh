#! /bin/bash
# @author DarKnight

unset PASSWORD
unset CHARCOUNT
unset USERNAME

echo -n "Enter ip address of proxy server(Leave blank if not applicable):" 
read proxy_ip
if [ -n "$proxy_ip" ] ; then
	echo -n "Proxy server port:" 
	read proxy_port
	echo "$proxy_ip $proxy_port" >> proxy.dat
	export http_proxy="http://${proxy_ip}:${proxy_port}"
	echo -n "Enter username (if applicable):" 
	read USERNAME
	is_proxy=1
	if [ -n "$USERNAME" ] ; then
		echo -n "Enter password: "
		stty -echo
		CHARCOUNT=0
		is_proxy=2
		while IFS= read -p "$PROMPT" -r -s -n 1 CHAR
		do
			# Enter - accept password
			if [[ $CHAR == $'\0' ]] ; then
				break
			fi
			# Backspace
			if [[ $CHAR == $'\177' ]] ; then
				if [ $CHARCOUNT -gt 0 ] ; then
				    CHARCOUNT=$((CHARCOUNT-1))
				    PROMPT=$'\b \b'
				    PASSWORD="${PASSWORD%?}"
				else
				    PROMPT=''
				fi
			else
				CHARCOUNT=$((CHARCOUNT+1))
				PROMPT='*'
				PASSWORD+="$CHAR"
			fi
		done
		stty echo 
		echo $USERNAME >> auth.dat
		echo $PASSWORD >> auth.dat
		export http_proxy="http://${USERNAME}:${PASSWORD}@${proxy_ip}:${proxy_port}"
	fi
fi
echo

wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ $? -eq 0 ]]; then
	echo "Online"
else
	echo "You are not connected to internet."
	echo "Restart the script when connected"
	exit 0
fi 

bash download.sh
mkdir -p scripts
unzip -q "*.zip" -x "*udp*" -d "scripts/" >> /dev/null
rm -rf "*.zip"
python2 list.py http://www.vpnbook.com proxy 1 >> /dev/null
if [ ! -f "authv.dat" ]; then
	echo "Password grabbing failed"
	echo "Report error"
	rm -rf *
	exit 0
fi
bash edit.sh
rm -rf scripts/
mv *.dat .script/
mv .script ~/.script
rm -rf *




