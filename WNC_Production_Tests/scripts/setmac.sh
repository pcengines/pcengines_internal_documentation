#!/usr/local/bin/bash
	echo "initializing NICs ..." 0
	echo -n "Enter serial number: "
	read sn
	sn=`echo $sn | tr '_' '\n' | head -n 1`
	sn=`echo "${sn//[!0-9]/}"`

	mac=$(expr $sn + 64)
	mac=$(expr $mac \* 4)
	mac1=`printf 000db9%06x $mac`
	mac=$(expr $mac + 1)
	mac2=`printf 000db9%06x $mac`
	mac=$(expr $mac + 1)
	mac3=`printf 000db9%06x $mac`
	echo 1st MAC adr = $mac1
	echo 2nd MAC adr = $mac2
	echo 3rd MAC adr = $mac3

	#./apu2/eeupdate32 /NIC=1
	eeupdate32 /NIC=1 /MAC=$mac1
	eeupdate32 /NIC=2 /MAC=$mac2
	eeupdate32 /NIC=3 /MAC=$mac3

	#determine RAM size
	#free -m | head -n2 | tail -n1 | awk '{print $2}'
	#1897
	if [ `free -m | head -n2 | tail -n1 | awk '{print $2}'` = "1897" ]
	then
			eeupdate32 /NIC=1 /INVMUPDATE /FILE=I211_Invm_APM_v0.6.txt
			eeupdate32 /NIC=2 /INVMUPDATE /FILE=I211_Invm_APM_v0.6.txt
			eeupdate32 /NIC=3 /INVMUPDATE /FILE=I211_Invm_APM_v0.6.txt
			echo "I211 initialized" 0				
	else
			eeupdate32 /NIC=1 /INVMUPDATE /FILE=/root/I210_Invm_Copper_APM_v0.6.txt
			eeupdate32 /NIC=2 /INVMUPDATE /FILE=/root/I210_Invm_Copper_APM_v0.6.txt
			eeupdate32 /NIC=3 /INVMUPDATE /FILE=/root/I210_Invm_Copper_APM_v0.6.txt
			echo "I210 initialized" 0				
	fi

	echo 1st MAC adr = $mac1
	echo 2nd MAC adr = $mac2
	echo 3rd MAC adr = $mac3
	echo "NIC's initialized! reboot required." 1



