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
# Commands configuration
########################################################################
PROCCOUNT=`ps -Afl | wc -l`
PROCCOUNT=`expr $PROCCOUNT - 5`
GROUPZ=`groups`
USER=`whoami`
ADMINS=`cat /etc/group | grep --regex "^sudo" | awk -F: '{print $4}' | tr ',' '|'`
ADMINSLIST=`grep -E $ADMINS /etc/passwd | tr ':' ' ' | tr ',' ' ' | awk {'print $5,$6,"("$1")"'} | tr '\n' ',' | sed '$s/.$//'`
UPDATESAVAIL=`cat /var/zzscriptzz/MOTD/updates-available.dat`

cur_temperature=$(cat /sys/class/thermal/thermal_zone0/temp)
cur_temperature=$(echo "$cur_temperature/1000" | bc -l | xargs printf "%1.0f")

# get the load averages
read one five fifteen rest < /proc/loadavg

if [[ $GROUPZ == "$USER sudo" ]]; then
USERGROUP="Administrator"
elif [[ $USER = "root" ]]; then
USERGROUP="Root"
elif [[ $USER = "$USER" ]]; then
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
    ${C2}__    __     ______   __            _____     ______     __   __  
   /\ .-./  \   /\__  _\ /\ \          /\  __-.  /\  ___\   /\ \ / /  
   \ \ \-./\ \  \/_/\ \/ \ \ \____     \ \ \/\ \ \ \  __\   \ \ \ /   
    \ \_\ \ \_\    \ \_\  \ \_____\     \ \____-  \ \_____\  \ \__|   
     \/_/  \/_/     \/_/   \/_____/      \/____/   \/_____/   \/_/ 	  
"

echo -e " ${C1} ++++++++++++++++++++++++: ${C3}System Data${C1} :+++++++++++++++++++++++++++
${C1} + ${C3}Hostname       ${C1}=  ${C4}`hostname`
${C1} + ${C3}IPv4 Address   ${C1}=  ${C4}`wget http://ipinfo.io/ip -qO -` ${C0}(`ip addr list eth0 |grep "inet " |cut -d' ' -f6|cut -d/ -f1`)
${C1} + ${C3}Uptime         ${C1}=  ${C4}`uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* users.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/'`
${C1} + ${C3}Time           ${C1}=  ${C0}`date`
${C1} + ${C3}CPU T°         ${C1}=  ${C0}$cur_temperature°C
${C1} + ${C3}Load Averages  ${C1}=  ${C4}${one}, ${five}, ${fifteen} ${C0}(1, 5, 15 min)
${C1} + ${C3}Distro         ${C1}=  ${C4}`cat /etc/*release | grep "PRETTY_NAME" | cut -d "=" -f 2- | sed 's/"//g'` ${C0}(`uname -r`)
${C1} + ${C3}CPU            ${C1}=  ${C4}`cat /proc/cpuinfo | grep "model name" | cut -d ' ' -f3- | awk {'print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10'} | head -1`
${C1} + ${C3}Memory         ${C1}=  ${C4}`free -m | awk '/Mem/ { printf("%3.1f%%", $3/$2*100) }'` ${C0}(`free -t -m | grep "Mem" | awk {'print $4'}`MB Free, `free -t -m | grep "Mem" | awk {'print $3'}`MB/`free -t -m | grep "Mem" | awk {'print $2'}`MB Used)
${C1} + ${C3}Swap           ${C1}=  ${C4}`free -m | awk '/Swap/ { printf("%3.1f%%", $3/$2*100) }'` ${C0}(`free -t -m | grep "Swap" | awk {'print $4'}`MB Free, `free -t -m | grep "Swap" | awk {'print $3'}`MB/`free -t -m | grep "Swap" | awk {'print $2'}`MB Used)
${C1} + ${C3}HDD Usage      ${C1}=  ${C4}`df -H | grep "/dev/root" | awk '{ print $5 }'` ${C0}(`df -hT | grep "/dev/root" | awk {'print $5'}`B Free, `df -hT | grep "/dev/root" | awk {'print $4'}`B/`df -hT | grep "/dev/root" | awk {'print $3'}`B Used)
${C1} + ${C3}Updates        ${C1}=  ${C4}$UPDATESAVAIL ${C0}"Updates Available"
${C1} ++++++++++++++++++++++++: ${C3}User Data${C1} :+++++++++++++++++++++++++++++
${C1} + ${C3}Username       ${C1}=  ${C4}`whoami` ${C0}($USERGROUP)
${C1} + ${C3}Last Login     ${C1}=  ${C4}`last -a $USER | head -2 | awk 'NR==2{print $3,$4,$5,$6}'` from `last -a $USER | head -2 | awk 'NR==2{print $10}'`
${C1} + ${C3}Sessions       ${C1}=  ${C4}`who | grep $USER | wc -l`
${C1} + ${C3}Processes      ${C1}=  ${C4}$PROCCOUNT of `ulimit -u` max
${C1} ++++++++++++++++++++: ${C3}Helpful Information${C1} :+++++++++++++++++++++++
${C1} + ${C3}Administrators ${C1}=  ${C4}$ADMINSLIST
${C1} ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"
