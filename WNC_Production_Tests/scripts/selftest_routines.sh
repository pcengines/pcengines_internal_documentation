#!/bin/bash

i210="/media/TINYCORE/I210_Invm_Copper_APM_v0.6.txt"
i211="/media/TINYCORE/I211_Invm_APM_v0.6.txt"
i210fiber="/media/TINYCORE/I210_Invm_SerDesKX_APM_v0.6.txt"
i210_bin="/media/TINYCORE/Dev_Start_I210_Fiber_NOMNG_16Mb_A2_3.25_0.03.bin"

function echo_pass(){
	echo "PASS : " $1
}

function echo_fail(){
	echo "FAIL : " $1
	let complete_test_status++
}

function echo_message(){
	echo "      **************************************************************************** "
	echo "     : " $1
}


function turn_on_nic_leds(){
	#disable all NICs
	total_nics=$1
	counter=0
	while [ $counter -ne $total_nics ]
	do
		command="ifconfig eth$counter up"
		`$command`
		((counter++))
	done
}


function check_bios(){
	bios_date=$1
	board_name=$2
	if [[ `dmidecode | grep Date | tr '\ ' '\n' | tail -n 1` != $bios_date || `dmidecode | grep "Product Name" | tr '\ ' '\n' | tail -n 1` != $board_name ]] ; then
		echo "FAIL" 
	else
		echo "PASS" 
	fi
}

function flash_bios(){
	bios_file=$1
	flashrom -w $bios_file -p internal:boardmismatch=force
}


function count_initialized_nics(){
	echo `ifconfig -a | grep eth | wc -l`
}

function init_intel_nics(){

	#nic_configured=`ifconfig -a | grep eth | wc -l`
	#if [ "$macadr_eth0" != "$macadr_eth1" ]; then 	
	if [ `ifconfig -a | grep eth | wc -l` -lt $total_nics ]; then 	
		echo "initializing MAC Addresses ..."

		while true; do # testing loop 
			echo

			read -p "Enter serial number: " rsn

			if [ `grep  -c '^WN[1-4][0-9]\{6\}_[0-9]\{4\}$' <<< "$rsn"` != 1 ]; then
				echo "ERROR: Wrong serial number: $rsn"
			else
		
				sn=`sed -e 's|^WN\(.......\)_.*$|\1|' <<< "$rsn"`
				echo "Serial: '$sn'"
	
				let mac='(sn+64)*4'


				i=1
				while [ "$i" -le "$total_nics" ]; do 
						mac1=`printf 000db9%06x $mac`
						echo MAC $i adr = $mac1
						eeupdate32 /NIC=$i /MAC=$mac1
						mac=$(expr $mac + 1)
				        let i++
				done

#	1531 	I210-AT hardware default, indicating an unprogrammed device
#	1532 	I211-AT hardware default, indicating an unprogrammed device
#	1533	I210-AT Gigabit Network Connection	
#	1534
#	1535
#	1536	I210-IS/AS Gigabit Fiber Network Connection
#	1537	I210-IS/AS Gigabit Backplane Connection
#	1538	I210-IS/AS Gigabit Network Connection
#	1539	I211-AT Gigabit Network Connection
#	157b  	I210-AT Gigabit Network Connection, using iNVM (no flash memory)
#	157c  	I210-IS/AS Gigabit Backplane Connection, using iNVM (no flash memory)
#
#
#	lspci for i210-AS before init:
#	01:00.0 Ethernet controller: Intel Corporation Device 1531 (rev 03)
#
#	lspci for i211 before init:
#	01:00.0 Class 0200: Device 8086:1532 (rev 03)                                                                                          
#
#	lspci for i210 after init:
#	01:00.0 Ethernet controller: Intel Corporation Device 157b (rev 03)                                                                    
#
#	lspci for i211 after init:
#	01:00.0 Ethernet controller: Intel Corporation Device 1539 (rev 03)                                                                    



				i=1
				while [ "$i" -le "$total_nics" ]; do
					pci_id=`eeupdate32 /NIC=$i /PCIINFO | tail -n 2 | head -n 1 | tr ' ' '\n' | head -n 12 | tail -n 1`

					if [[ "$pci_id" == "8086-1531" ]]; then
						if [[ "$board_name" == "apu6" ]]; then
							eeupdate32 /NIC=$i /INVMUPDATE /FILE=$i210fiber
							#eeupdate32 /BUS=1 /DEV=0 /DATA $i210_bin
						else
							eeupdate32 /NIC=$i /INVMUPDATE /FILE=$i210
						fi

					elif [[ "$pci_id" == "8086-1532" ]]; then
						eeupdate32 /NIC=$i /INVMUPDATE /FILE=$i211

					elif [[ "$pci_id" == "8086-1539" ]]; then
						echo "i211 already initialized"

					elif [[ "$pci_id" == "8086-157B" ]]; then
						echo "i210 already initialized"

					elif [[ "$pci_id" == "8086-1536" ]]; then
						echo "i210-IS/AS already initialized"

					elif [[ "$pci_id" == "8086-157C" ]]; then
						echo "i210-IS/AS already initialized"

					else
						echo "Cannot identify NICS"

					fi
			        let i++
				done

				echo "NIC's initialized."

				reboot=1

				break # End on success
			fi


		done

	fi
	echo "NIC's initialized!"
}


function check_lpc_fw(){
	lpc_fw_version=$1

	p0="/tmp/verio"
	p1="/tmp/verout"
	rm -f $p0
	mkfifo $p0
	cat $p0 | lpc_com_09 > $p1 &
	pid=$!
	(
	sleep 1
	echo 'v'
	sleep 1
	) > $p0
	kill $!

	ver=`grep '^V = ' $p1 | cut -d"'" -f2`
	#echo $ver
	rm -f $p0 $p1

	if [[ $ver != $lpc_fw_version ]]
	then
		echo "FAIL"
	else
		echo "PASS" 
	fi
}


function get_mem_size(){
	echo -n "System Memory " `cat /proc/meminfo | grep MemTotal | awk '{ print $2 }'` "kB"
}


function get_eth_mac() {
	# $1 - eth name
	cat /sys/class/net/$1/address
}

#get_eth_names() {
	#eth_names=`ls -d  /sys/class/net/e* | sed -e 's|^.*/||' | tr '\012' ' '`
	#eth_count=`wc -w <<< "$eth_names"`
#}

function check_macadr(){
	eth_names=`ls -d  /sys/class/net/e* | sed -e 's|^.*/||' | tr '\012' ' '`
	eth_count=`wc -w <<< "$eth_names"`

	mac_fails=0
	eth_names=`ls -d  /sys/class/net/e* | sed -e 's|^.*/||' | tr '\012' ' '`

	for eth in $eth_names; do
		mac=`get_eth_mac $eth`
		#echo "$eth: $mac"

		# MAC matches pattern?
		if [ `grep -c '^[0-9a-f][0-9a-f]\(:[0-9a-f][0-9a-f]\)\{5\}$' <<< $mac` != 1 ]; then
			echo "MAC address ($mac) of $eth is not set correct"
			let mac_fails++
		fi

		# Check leading part of MAC addr
		if [ ${mac:0:8} != '00:0d:b9' ]; then
			echo "MAC address ($mac) of $eth is not set correct"
			let mac_fails++
		fi
	done

	# Check for uniqueness
	#if [ `cd /sys/class/net/ ; grep -h . e*/address | uniq | wc -l` != $eth_count ]; then
	if [[ `grep -h . /sys/class/net/e*/address | uniq | wc -l` != $eth_count ]]; then

		echo "MAC addresses are not unique:"
		for eth in $eth_names; do
			mac=`get_eth_mac $eth`
			echo "$eth: $mac"
		done
		let mac_fails++
	fi

	if [ $mac_fails = 0 ]; then
		echo "PASS"
	else
		echo "FAIL"
		let complete_test_status++
	fi
}	

function check_msata(){
	sata=`ls -la /sys/block/ | grep -i ata | wc -l`
	if ! [ "$sata" -gt "0" ]; then 	
		echo "No mSATA device found."
		let complete_test_status++
	else
		echo "PASS"
	fi
}

function check_usb(){
	usb_test_status=0;
	for i in ${usb_sticks[@]}
	do
		if [ `ls -l /dev/disk/by-label/ | grep $i | wc -l` != 1 ]; then
			let usb_test_status++
			echo "USB stick $i not found! "
		fi
	done

	if [ $usb_test_status = "0" ]; then 
		echo "PASS"
		#else; #echo "FAIL" #enough error messages written, no more needed
	fi	
}


function check_sd(){
	sd=`ls -la /dev| grep mmcblk0  | wc -l`
	if ! [ "$sd" -gt "0" ];	then 	
		echo "No SD card found."
	else
		echo "PASS"
	fi
}

function check_buttonS1(){
	buttonS1=`readS1 5000 100`
	if [[ "$buttonS1" == "1" ]];	then 	
		echo "Button S1 not detected."
	else
		echo "PASS"
	fi
}


# =================
#  ETH tx/rx test
# =================

BASEN=100

eth_all_down() {
	eth_names=`ls -d  /sys/class/net/e* | sed -e 's|^.*/||' | tr '\012' ' '`
	for eth in $eth_names; do
		ifconfig $eth down
	done
}

eth_all_up() {
	# Bring all interfaces up on separate networks
	eth_names=`ls -d  /sys/class/net/e* | sed -e 's|^.*/||' | tr '\012' ' '`
	n=$BASEN
	for eth in $eth_names; do
		ifconfig $eth 192.168.$n.$n netmask 255.255.255.0 up
		let n++
	done


	timeout=3 #timeout in 10th_seconds
	for eth in $eth_names; do
			timeout=3000 #timeout 
			nic_state_command="cat /sys/class/net/$eth/operstate"
			nic_state="down"
			while [ $nic_state = "down" ] && [ $timeout != 0 ] ; do 
				nic_state=`$nic_state_command`
				usleep 100;
				((timeout--))
			done
	done

	for eth in $eth_names; do
		nic_state_command="cat /sys/class/net/eth$counter/operstate"
		if [  `$nic_state_command` = "down" ] ; then
			echo -n "failed to bring interface $eth up"
			echo "FAIL"
			eth0_status=0
			let eth_fail++
		fi
	done
}


# $1 - eth ifc name
parse_ifstat() {
	local out eth err
	
	eth=$1
	parse_fail=0
	eth_err=0

	out=( `ifstat $eth | grep -v '\(kernel\|Rate\)'` )
	if [ ${out[0]} != $eth -o ${#out[@]} != 17 ]; then
		parse_fail=1
		return
	fi

	echo "${out[@]}"

	err=`echo "${out[@]:9:8}"`

	if [ "$err" != '0 0 0 0 0 0 0 0' ]; then
		eth_err=1
		return
	fi

	eth_rx=${out[1]}
	eth_tx=${out[3]}
}


# $1 - description
add_eth_fail_desc() {
	eth_fail_desc="${eth_fail_desc}$1\n"
}



# General testing function - don't use directly
check_eths_base() {
	eth_names=`ls -d  /sys/class/net/e* | sed -e 's|^.*/||' | tr '\012' ' '`

	eth_fail=0
	eth_fail_desc=''

	eth_all_down
	eth_all_up

	# Wait for ifstat after ifc ups
	ifstat
	sleep 5

	# Check whether all ifcs are up
	for eth in $eth_names; do
		if [ `cat /sys/class/net/$eth/operstate` != up ]; then
			add_eth_fail_desc "Interface $eth down."
			let eth_fail++
		fi
	done

	# Continue only if all interfaces are up
	if [ $eth_fail = 0 ]; then

		# Ping to nonexistent addr on each subnet forcing ARP on all interfaces
		(
			n=$BASEN
			for eth in $eth_names; do
				ping -q -c 1 192.168.$n.77 &
				let n++
			done
			#wait # We don't need to wait for the end
			sleep 3
		)

		# Evaluate stat from each ifc
		for eth in $eth_names; do
			parse_ifstat $eth
			if [ $parse_fail != 0 ]; then
				add_eth_fail_desc "Fail parsing ifstat $eth"
				let eth_fail++
			elif [ $eth_err != 0 ]; then
				add_eth_fail_desc "Communication error on $eth"
				let eth_fail++
			else
				if [ $eth_rx = 0 ]; then
					add_eth_fail_desc "No data received at $eth"
					let eth_fail++
				fi
				if [ $eth_tx = 0 ]; then
					add_eth_fail_desc "No data sent at $eth"
					let eth_fail++
				fi
				echo -n "($eth:$eth_rx:$eth_tx)"
			fi
		done

	fi

	eth_all_down
}

# =====================
#  ETH tx/rx test END
# =====================

# ----
# Replace this functions to make required output
# ----
check_eths() {
	check_eths_base > /dev/null 2>&1 # Comment-out redirection for debugging
	if [ $eth_fail != 0 ]; then
		#echo "FAIL"
		echo -e "$eth_fail_desc" | sed -e 's|^|  |'
	else
		echo "PASS"
	fi
}


