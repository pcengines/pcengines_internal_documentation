#!/bin/bash
	# PATH=$PATH:/media/TINYCORE/
	source /media/TINYCORE/selftest_routines.sh
	test_version="20181019"

	board_name="APU2"
	bios_file="./coreboot/apu2_v4.0.7.rom"
	bios_date="02/28/2017"

	total_nics=1

	# firmware for LPC11C14 only needed for apu5
	#lpc_fw="./fw_apu5b_21.bin"
	#lpc_fw_version="LPC_CAN.21"

	# array "usb_sticks" contains the labels of USB sticks to be tested
	usb_sticks=(USB1 USB2 USB3)

	reboot=0

	complete_test_status=0;

# *************************************************************************************
#  script beginning
# *************************************************************************************
	echo_message "starting test on $board_name ($test_version)"


# *************************************************************************************
#  check mem size (needed?)
# *************************************************************************************

	mem_size=`get_mem_size`
	echo_message "$mem_size"


# *************************************************************************************
#  turn on all NIC LEDs
# *************************************************************************************
	echo_message "Turning on all NIC LEDs"
	turn_on_nic_leds $total_nics


# *************************************************************************************
#  checking BIOS version
# *************************************************************************************
	echo_message "Checking BIOS version ..."

	bios_ok=`check_bios $bios_date $board_name`

	if [[ $bios_ok != "PASS" ]]
	then
		echo_fail "BIOS not correct"
		flash_bios $bios_file
		let reboot++
	else
		echo_pass "BIOS correct"
	fi

# *************************************************************************************
#  checking NICs
# *************************************************************************************
	echo_message "Checking NICs"
	
	nic_count=`count_initialized_nics`
	if [[ $total_nics != $nic_count ]]
	then
		echo_fail "found $nic_count of $total_nics un-initialized NICs"
		init_intel_nics $total_nics
		let reboot++		
	else
		echo_pass "all $nic_count nics initialized"
	fi



# *************************************************************************************
#  reboot needed after BIOS update or after NIC init
# *************************************************************************************
	if [[ $reboot != 0 ]]; then 
		echo "rebooting now ...."
		reboot
	fi



# *************************************************************************************
#  check button S1
# *************************************************************************************
	echo_message "Checking button S1. Press button now ..."

	button_test=`check_buttonS1`
	if [[ $button_test != "PASS" ]]
	then
		echo_fail "$button_test"
	else
		echo_pass "Button S1 detected"
	fi
	

# *************************************************************************************
#  check MAC addresses
# *************************************************************************************
	echo_message "Checking MAC addresses"

	valid_macadr=`check_macadr`
	if [[ $valid_macadr != "PASS" ]]
	then
		echo_fail "$valid_macadr"
	else
		echo_pass "MAC addresses plausible"
	fi


# *************************************************************************************
#  check mSATA
# *************************************************************************************
	echo_message "Checking mSATA"

	msata_test=`check_msata`
	if [[ $msata_test != "PASS" ]]
	then
		echo_fail "$msata_test"
	else
		echo_pass "mSATA found"
	fi
	

# *************************************************************************************
#  check USB
# *************************************************************************************
	echo_message "Checking USB"

	usb_test=`check_usb`
	if [[ $usb_test != "PASS" ]]
	then
		echo_fail "$usb_test"
	else
		echo_pass "USB found"
	fi
	

# *************************************************************************************
#  check SD
# *************************************************************************************
	echo_message "Checking SD"

	sd_test=`check_sd`
	if [[ $sd_test != "PASS" ]]
	then
		echo_fail "$sd_test"
	else
		echo_pass "SD found"
	fi
	

# *************************************************************************************
#  check single NICs eth0
# *************************************************************************************
	echo_message "Checking NICs"
	# server_ip="192.168.1.100"
	dut_ip="192.168.1.100"
	ifconfig eth0 $dut_ip
	if [[ `cat /sys/class/net/eth0/operstate` == 'up' ]]
	# if ping -c 1 $server_ip &> /dev/null
	then
	  eth_test="PASS"
	else
	  # eth_test="No reply from test server on PING"
	  eth_test="Link eth0 down"
	fi

	# eth_test=`check_eths`
	if [[ $eth_test != "PASS" ]]
	then
	        echo_fail "$eth_test"
	else
	        echo_pass "all NICs OK"
	fi


# *************************************************************************************
#  Display result
# *************************************************************************************
	echo_message "Overall test result:"
	if [[ $complete_test_status != "0" ]]
	then 
		echo_fail "Overall test FAILED"
	else 
		echo_pass "Overall test PASSED"
	fi
