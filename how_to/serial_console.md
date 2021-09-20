# Serial Console

The loop-back test: put a paper clip in the female DB9 connector which would go on the alix/apu board at pins 2 and 3, then you should receive typed characters in your terminal emulation program. This tests the terminal emulation program, the USB-RS232 and the serial cable and this test MUST work before blaming any board attached to it. But this test does not prove whether or not a null-modem cable is used.

The most common mistake people make is not using a null-modem cable: If you have a multimeter, check that the pins 2 and 3 are crossed. Do NOT use gender changers!

The default baud rate for alix boards is 38400,8n1 and for apu boards 115200,8n1.

The recommended terminal emulation program for any platform is PuTTY.

Pressing the button S1 while powering up, temporarily enables a previously in the BIOS disabled serial console.

To test if an apu board boots up, even if there is no serial console, boot it with TinyCore and a beep should be heard after about 30s-40s.

[back](./)
