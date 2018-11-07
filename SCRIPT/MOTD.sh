#!/bin/bash
clear && printf '\e[3J'
########################################################################
# Color esthetics
########################################################################
C0='\033[1;37m' # White
C1='\033[0;35m' # Purple
C2='\033[0;32m' # Green
C3='\033[0;37m' # Light Gray
C4='\033[1;32m' # Light Green
C5='\033[0;31m' # Red
C6='\033[1;33m' # Yellow
C7='\033[0;34m' # Blue

########################################################################
# Parameters
########################################################################

# CPU Temperature default is in degrees Celsius
# You can output it in Degrees Farenheit by changing the parameter below
# to true
isCPUTempFarenheit=false

########################################################################
# Commands configuration
########################################################################
PROCCOUNT=$(ps -Afl | wc -l)
PROCCOUNT=$((PROCCOUNT - 5))
GROUPZ=$(groups)
USER=$(whoami)
ADMINS=$(grep --regex "^sudo" /etc/group | awk -F: '{print $4}' | tr ',' '|')
ADMINSLIST=$(grep -E $ADMINS /etc/passwd | tr ':' ' ' | tr ',' ' ' | awk '{print $5,$6,"("$1")"}' | tr '\n' ',' | sed '$s/.$//')
UPDATESAVAIL=$(cat /var/zzscriptzz/MOTD/updates-available.dat)
INTERFACE=$(route | grep '^default' | grep -o '[^ ]*$')

if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
	cur_temperature=$(cat /sys/class/thermal/thermal_zone0/temp)

	if [ "$isCPUTempFarenheit" = true ]; then
		cur_temperature="$(echo "$cur_temperature / 1000" | bc -l | xargs printf "%.2f")"
		cur_temperature="$(echo "$cur_temperature * 1.8 + 32" | bc -l | xargs printf "%1.0f") °F"
	else
		cur_temperature="$(echo "$cur_temperature / 1000" | bc -l | xargs printf "%1.0f")°C"
	fi
else
        cur_temperature="N/A"
fi

OPEN_PORTS_IPV4=$(netstat -lnt | awk 'NR>2{print $4}' | grep -E '0.0.0.0:' | sed 's/.*://' | sort -n | uniq | awk -vORS=, '{print $1}' | sed 's/,$/\n/')
OPEN_PORTS_IPV6=$(netstat -lnt | awk 'NR>2{print $4}' | grep -E ':::' | sed 's/.*://' | sort -n | uniq | awk -vORS=, '{print $1}' | sed 's/,$/\n/')

ps_output="$(ps aux)"
processes="$(printf "%s\\n" "${ps_output}" | wc -l)"
mem_top_processes="$(printf "%s\\n" "${ps_output}" | awk '{print "\033[1;37m"$2, $4"%", "\033[1;32m"$11}' | sort -k2rn | head -3 | awk '{print " \033[0;35m+\t\033[1;32mID: "$1, $3, $2}')"
cpu_top_processes="$(printf "%s\\n" "${ps_output}" | awk '{print "\033[1;37m"$2, $3"%", "\033[1;32m"$11}' | sort -k2rn | head -3 | awk '{print " \033[0;35m+\t\033[1;32mID: "$1, $3, $2}')"


# get the load averages
read -r one five fifteen rest < /proc/loadavg

if [[ "$GROUPZ" == *"sudo"* ]]; then
        USERGROUP="Administrator"
elif [[ "$USER" == "root" ]]; then
        USERGROUP="Root"
elif [[ "$USER" == "$USER" ]]; then
        USERGROUP="Regular User"
else
        USERGROUP="$GROUPZ"
fi

echo -e " ${C0}+                    +                     +         +
                                 +                  +           +
          +                                             +
                                       \ /
                      +     _        - _+_ -                    ___${C3}
        _${C6}=.${C0}    ${C5}.:.${C3}         /${C6}=${C3}\       _|${C0}===${C3}|_                  || ${C6}::${C3}|
       |  |    _${C5}|.${C3}        |   |     | |   | |     __${C7}===${C3}_  ${C0}-=-${C3} || ${C6}::${C3}|
       |${C6}==${C3}|   |  |  __    |${C6}.:.${C3}|   /\| | ${C6}:.${C3}| |    |   | ${C6}.${C3}|| ${C6}:${C3} ||| ${C6}::${C3}|
       |  |-  |${C6}.:${C3}|_|${C6}. :${C3}__ |${C6}.:${C3} |--|${C6}==${C3}| |  ${C6}.${C3}| |_   | ${C6}.${C3} |${C6}.${C3} ||${C6}.${C3}  ||| ${C6}:.${C3}|
     __|${C6}.${C3} | |_|${C6}.${C3} | |${C6}.${C3}|${C6}...${C3}||---|  |${C6}==${C3}| |   | | |_--${C6}.${C3}     ||   |||${C6}.${C3}  |
    |  |  |   |${C6}.${C3} | | |${C6}::.${C3}|| ${C6}:.${C3}|  |${C6}==${C3}| | ${C6}. :${C3} |${C6}=${C3}|${C6}===${C3}|    ${C6}:${C3}|| ${C6}.${C3} |||  ${C6}.${C3}|
    |${C6}:.${C3}| ${C6}.${C3}|   |  | | |${C6}:.:${C3}|| ${C6}.${C3} |  |${C6}==${C3}| |     |${C6}=${C3}|${C6}===${C3}|${C6} .${C3}   |    | |   |
    |     |      |   |   |            :   .   |   ;     ;          |
          :          :                .          .      .          :
"

echo -e "${C1} ++++++++++++++++++++++++: ${C3}System Data${C1} :+++++++++++++++++++++++++++
${C1} + ${C3}Hostname       ${C1}=  ${C4}$(hostname) ${C0}($(hostname --fqdn))
${C1} + ${C3}IPv4 Address   ${C1}=  ${C4}$(wget http://ipinfo.io/ip -qO -) ${C0}($(ip addr list $INTERFACE | grep "inet " | cut -d' ' -f6| cut -d/ -f1))
${C1} + ${C3}Uptime         ${C1}=  ${C4}$(uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* user.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/')
${C1} + ${C3}Time           ${C1}=  ${C0}$(date)
${C1} + ${C3}CPU Temp       ${C1}=  ${C0}$cur_temperature
${C1} + ${C3}Processes      ${C1}=  ${C4}$PROCCOUNT of $(ulimit -u) max
${C1} + ${C3}Load Averages  ${C1}=  ${C4}${one}, ${five}, ${fifteen} ${C0}(1, 5, 15 min)
${C1} + ${C3}Distro         ${C1}=  ${C4}$(grep "PRETTY_NAME" /etc/*release | cut -d "=" -f 2- | sed 's/"//g') ${C0}($(uname -r))
${C1} + ${C3}CPU            ${C1}=  ${C4}$(grep "model name" /proc/cpuinfo | cut -d ' ' -f3- | awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10}' | head -1)
${C1} + ${C3}Memory         ${C1}=  ${C4}$(free -m | awk '/Mem/ { printf("%3.1f%%", $3/$2*100) }') ${C0}($(free -t -m | grep "Mem" | awk '{print $4}')MB Free, $(free -t -m | grep "Mem" | awk '{print $3}')MB/$(free -t -m | grep "Mem" | awk '{print $2}')MB Used)
${C1} + ${C3}Swap           ${C1}=  ${C4}$(free -m | awk '/Swap/ { printf("%3.1f%%", $3/$2*100) }') ${C0}($(free -t -m | grep "Swap" | awk '{print $4}')MB Free, $(free -t -m | grep "Swap" | awk '{print $3}')MB/$(free -t -m | grep "Swap" | awk '{print $2}')MB Used)
${C1} + ${C3}HDD Usage      ${C1}=  ${C4}$(df -H | grep "/$" | awk '{ print $5 }') ${C0}($(df -hT | grep "/$" | awk '{print $5}')B Free, $(df -hT | grep "/$" | awk '{print $4}')B/$(df -hT | grep "/$" | awk '{print $3}')B Used)
${C1} + ${C3}Updates        ${C1}=  ${C4}$UPDATESAVAIL ${C0}"Updates Available"
${C1} ++++++++++++++++++++: ${C3}Top CPU Processes${C1} :+++++++++++++++++++++++++
$cpu_top_processes${C0}
${C1} ++++++++++++++++++++: ${C3}Top Mem Processes${C1} :+++++++++++++++++++++++++
$mem_top_processes${C0}
${C1} ++++++++++++++++++++++++: ${C3}User Data${C1} :+++++++++++++++++++++++++++++
${C1} + ${C3}Username       ${C1}=  ${C4}$USER ${C0}($USERGROUP)
${C1} + ${C3}Last Login     ${C1}=  ${C4}$(last -a $USER | head -2 | awk 'NR==2{print $3,$4,$5,$6}') from $(last -a $USER | head -2 | awk 'NR==2{print $10}')
${C1} + ${C3}Sessions       ${C1}=  ${C4}$(who | grep -c $USER)
${C1} ++++++++++++++++++++: ${C3}Helpful Information${C1} :+++++++++++++++++++++++
${C1} + ${C3}Administrators ${C1}=  ${C4}$ADMINSLIST
${C1} + ${C3}OpenPorts IPv4 ${C1}=  ${C4}$OPEN_PORTS_IPV4
${C1} + ${C3}OpenPorts IPv6 ${C1}=  ${C4}$OPEN_PORTS_IPV6
${C1} ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"

