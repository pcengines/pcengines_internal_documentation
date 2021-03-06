# lpc1a

## Boards
The lpc1a is needed for the following boards as an alternative BIOS if on-board BIOS is not functional.

  * alix boards
  * apu1 boards

## Flash ROM size
The apu1 boards have a 16Mbit (2MB) flash chip and the BIOS files need to be the same size.

For use with smaller 8Mbit (1MB) flash chips use this minimized BIOS version: 

[apu1_v4.8.0.6_8mbit.zip](https://github.com/pcengines/pcengines_internal_documentation/files/7219025/apu1_v4.8.0.6_8mbit.zip)

## Flashing the lpc1a

Boot TinyCore Linux and run:

`flashrom -w apu1_${latest_bios_version}.rom -p internal:recovery_dongle=LPC`

## Image
![image](https://user-images.githubusercontent.com/18163327/134538528-fc98b688-2dca-4306-ac66-021d2c83276a.png)

## Schematics
![image](https://user-images.githubusercontent.com/18163327/134549737-233eb0e1-bc27-468c-a8f3-c6d1090d7cec.png)
