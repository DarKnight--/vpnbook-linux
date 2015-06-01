#! /bin/bash
# @author DarKnight

mkdir -p .script
vpn_file=`find scripts/ -type f -name "*.ovpn" -print`
vpn_main=`find scripts/ -type f -name "*.ovpn" -print -quit`
tail -n 16 $vpn_main | head -n 15 >> ".script/client.key"
tail -n 41 $vpn_main | head -n 23 >> ".script/client.crt"
tail -n 66 $vpn_main | head -n 23 >> ".script/ca.crt"
for file in ${vpn_file[@]} ; do
	head -n 17 $file | sed 's/auth-user-pass/auth-user-pass authv.dat/' >> ".script/${file#*-}"
	cat post.txt >> ".script/${file#*-}"
	case "$1" in
	1)
		echo "http-proxy-retry" >> ".script/${file#*-}"
		echo "http-proxy `cat proxy.dat`" >> ".script/${file#*-}"
	;;
	2)
		echo "http-proxy-retry" >> ".script/${file#*-}"
		echo "http-proxy `cat proxy.dat` auth.dat basic" >> ".script/${file#*-}"
	;;
	esac
done

