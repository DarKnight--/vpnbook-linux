#! /bin/bash
# @author DarKnight

progressbar ()
{
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c
    do
        if $flag
        then
            printf '%c' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}

declare -a url_data=("DE1" "US1" "US2" "Euro1" "Euro2" "CA1")
for f_name in ${url_data[@]} ; do
	url="http://www.vpnbook.com/free-openvpn-account/VPNBook.com-OpenVPN-${f_name}.zip"
	wget --progress=bar:force $url 2>&1 | progressbar
done
