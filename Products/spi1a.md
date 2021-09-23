# spi1a

![image](https://user-images.githubusercontent.com/18163327/134548760-8ed0f05b-66a5-41f6-9f8e-6654ae575674.png)

## Boards
The spi1a is needed for the following boards as an alternative BIOS if on-board BIOS is not functional.

  * apu2
  * apu3
  * apu4
  * apu5
  * apu6
  * apu7

## Flashing the lpc1a

`flashrom -w apu2_${latest_bios_version}.rom -p internal:recovery_dongle=SPI`

## Schematics
![image](https://user-images.githubusercontent.com/18163327/134549451-f96c0efa-2bb8-4f8f-b46a-61b3df992035.png)

