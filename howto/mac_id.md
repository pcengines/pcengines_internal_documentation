# MAC ID

The MAC address of the first NIC on all PC Engines boards is derived of its serial number, the following NICs have subsequent addresses.

Calculation from MAC ID to serial number and vice versa:

`MAC ID = 00:0d:b9 (our OUI) : (serial + 64) * 4`

`serial = (MAC ID & 0x000000FFFFFF) / 4 - 64`

<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript">

	function calculate_mac(serial_nr){
		serial_nr = parseInt(serial_nr.replace('?','_').split("_")[0].replace('WN',''), 10);
		var mac = (serial_nr+64)*4;
		mac = mac.toString(16);
		mac = "000000" + mac;
		mac = mac.substr(-6);
		mac = mac.substring(0,2) + ":" + mac.substring(2,4) + ":" + mac.substring(4,6);
		$("#mac_id").val('00:0d:b9:' + mac);
	};
	function calculate_serial(mac){
		serial_nr = mac.split(':').join('');
		var len = serial_nr.length;
		serial_nr = serial_nr.substring(len-6,len);
		serial_nr = parseInt(serial_nr, 16)/4-64;
		$("#serial_nr").val(Math.trunc(serial_nr));
	};

</script>

<table>
	<tr>
		<td>MAC ID</td>
		<td><input id="mac_id"></td>
		<td><button onclick="calculate_serial($('#mac_id').val())">calculate Serial number</button></td>
	</tr>
	<tr>
		<td>Serial number</td>
		<td><input id="serial_nr"></td>
		<td><button onclick="calculate_mac($('#serial_nr').val())">calculate MAC ID</button></td>
	</tr>
</table>
