# PC Engines ECN #066
11/15/2019

# Board: 

* apu2a, apu2b, apu2c, apu2d, apu2e
* apu3a, apu3b, apu3c
* apu4a, apu4b, apu4c, apu4d
* apu5a, apu5b, apu5c
* apu6a

## Intention: 
Avoid cold temperature startup problems.

## Effective: 
Immediate

## Issue: 
VNB supply insufficient for power-up surge with some AMD SOCs at low temperature (e.g. with cooling spray).

## Change: 
Change resistor value in feedback network from 4.99 k to 30k ohm.

See schematic page 16.

* apu2* location R77
* apu3* location R80
* apu4* location R75
* apu5* location R229
* apu6a location R86

