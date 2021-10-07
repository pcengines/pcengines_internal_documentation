#!/bin/bash
# posted in http://unix.stackexchange.com/a/275888/119298 by meuh
# see https://serverfault.com/q/127636/294707
#  cmcginty Apr 2 '10 and Steve Kehlet answered Sep 8 '11
#  
#  ipcrossover.sh config eth0 eth1
#  wget -O- http://10.60.0.1/random.bin > /dev/null

usage(){
        echo "$0: usage:
 config interface1 interface2
 show
 test
 tcpdump
 undo
This script sets up an iptables address translation to allow packets
to circulate over an external loopback cable between two interfaces.
You need to be root. Example usage:
 $0 config eth0:1 eth1
 $0 test
" >&2
        exit 1
}

getmac(){
        $setdebug
        local interface=${1?'interface'}
        ip link show $interface |
        awk '/link\/ether/ { print $2 }'
}
getaddr(){
        $setdebug
        local interface=${1?'interface'}
        ip addr show $interface |
        awk '/ inet / { split($2,x,"/"); print x[1] }'
}
# return true if have name of 2 interfaces
haveconfig(){
        $setdebug
        [ -n "$if1" -a -n "$if2" ] &&
        ip link show "$if1" &&
        ip link show "$if2"
}
# set variables from $if1 and $if2
setup(){
        $setdebug
        if ! haveconfig >/dev/null
        then    haveconfig >&2
                echo "Start with 'config' and 2 valid interfaces" >&2
                usage
        fi
        realprefix=10.50
        fakeprefix=10.60
        real1=$realprefix.0.1
        fake1=$fakeprefix.0.1
        real2=$realprefix.1.1
        fake2=$fakeprefix.1.1
        mac1=$(getmac $if1)
        mac2=$(getmac $if2)
}
doconfig(){
        doifconfig
        doiptables
        doroute
        doarp
        echo "eg: ping $fake2"
}
# Give IPs to the interfaces, and put them on separate networks:
doifconfig(){
        $setdebug
        ifconfig $if1 $real1/24
        ifconfig $if2 $real2/24
}

# set up a double NAT scenario: two new fake networks used to reach the
# other. On the way out, source NAT to your fake network. On the way in,
# fix the destination. And vice versa for the other network:
doiptables(){
        $setdebug
        # nat source IP $real1 -> $fake1 when going to $fake2
        iptables -t nat -A POSTROUTING -s $real1 -d $fake2 -j SNAT --to-source $fake1
        # nat source IP $real2 -> $fake2 when going to $fake1
        iptables -t nat -A POSTROUTING -s $real2 -d $fake1 -j SNAT --to-source $fake2

        # nat inbound $fake1 -> $real1
        iptables -t nat -A PREROUTING -d $fake1 -j DNAT --to-destination $real1
        # nat inbound $fake2 -> $real2
        iptables -t nat -A PREROUTING -d $fake2 -j DNAT --to-destination $real2
}

# tell the system how to get to each fake network
doroute(){
        $setdebug
        ip route flush cache
        ip route add $fake2 dev $if1 src $real1
        ip route add $fake1 dev $if2 src $real2
}
# prepopulate the arp entries
doarp(){
        $setdebug
        ip neigh add $fake2 lladdr $mac2 dev $if1
        ip neigh add $fake1 lladdr $mac1 dev $if2
}
doshow(){
        $setdebug
        iptables -L -t nat -v -n -x
        ip route get $fake1
        ip route get $fake2
        arp -n
}
# undo all configuration
doundo(){
        iptables -F -t nat
        ip route del $fake2 dev $if1
        ip route del $fake1 dev $if2 
        ip route flush cache
        #arp -i $realif1 -d $fake2
        #arp -i $realif2 -d $fake1
        ip neigh del $fake2 lladdr $mac2 dev $if1
        ip neigh del $fake1 lladdr $mac1 dev $if2
        ip addr del $real1/24 dev $if1
        ip addr del $real2/24 dev $if2
}
# tcpdump of just the wanted packets, in case using nfs on interface
dotcpdump(){
        tcpdump -n -e -i fm1-gb1 ether src $mac1 or ether src $mac2 or ether dst $mac1 or ether dst $mac2
}
showpacketcounts(){
        echo -n "$1 "
        local realif=${1%:*}
        ifconfig "$realif" |
        awk '/packets/{printf "%s %-20s",$1,$2; if(/TX/)printf "\n"}'
}
showiptablescounts(){
        iptables -L -t nat -v -x |
        awk '       $3~/[SD]NAT/ { result = result " " $1 " " $3}
                END {print "iptables counts " result }'
}
showcounts(){
        showpacketcounts $if1
        showpacketcounts $if2
        showiptablescounts
}
showdiffs(){
        echo -e "==\n$old\n==\n$new" |
        awk '/^==/{ part++; i = 0; next }
                { inp[part][++i] = $0 }
        END { end = i; for(i = 1;i<=end;i++)print inp[1][i] "\n" inp[2][i] }'
}
# use netstat -l -t to see what services you could test
dotest(){
        old=$(showcounts)
        for ip in $fake1 $fake2
        do      ping -c 4 $ip # -W 1
                echo
                traceroute -M udp $ip # -m 2
                echo
                rpcinfo -p $ip | head -3
                echo
        done
        new=$(showcounts)
        showdiffs
}

# eg ping $fake2 goes out $if1, the source IP $real1 gets NATted to $fake1,
# and as it comes into $if2 the destination $fake2 gets NATted to $real2.
# And the reply takes a similar journey.

# to use iperf to test throughput. Bind to the correct IPs, and be certain
# which IP you're contacting (the other end's fake address):
# server
#./iperf -B $real2 -s
# client: your destination is the other end's fake address
#./iperf -B $real1 -c $fake2 -t 60 -i 10

setdebug= 
case $- in
*x*)        setdebug='set -x' ;; 
esac
PATH=$PATH:/sbin:/usr/sbin

# read saved config
CONFIGFILE=~/.ipcrossover
if [ -s $CONFIGFILE ]
then        source $CONFIGFILE
fi

while [ $# -gt 0 ]
do      cmd=$1; shift
        case $cmd in
        config) if [ $# -ge 2 ] && ip link show "$1" >/dev/null
                then    if1=$1
                        if2=$2
                        shift 2
                        echo "if1=$if1; if2=$if2" >$CONFIGFILE
                fi
                setup
                doconfig ;;
        show|test|undo|tcpdump)
                setup
                do$cmd ;;
        *)      usage ;;
        esac
done
