# tpm1a

## Usage
See [https://pcengines.github.io/apu2-documentation/tpm_menu/](https://pcengines.github.io/apu2-documentation/tpm_menu/)

## Board compatibility
The tpm1a can be used with

  * apu2

## Testing the tpm1a module

```bash
#!/bin/bash

display_usage() { 
  echo -e "\nUsage:$0 /dev/ttyUSB[0 .. n] \n" 
  } 

# if less than one arguments supplied, display usage 
  if [  $# -le 0 ] 
  then 
    display_usage
    exit 1
  fi 
 
# check whether user had supplied -h or --help . If yes display usage 
  if [[ ( $# == "--help") ||  $# == "-h" ]] 
  then 
    display_usage
    exit 0
  fi 
 
######################################################################
# starting here ...
######################################################################
exec 4<$1 5>$1
stty -F $1 115200 -echo

while :
do
  read reply <&4
  echo "$reply"
  f10=`echo $reply | grep -i "F10" |head -c 9`
  #echo F10=$f10
  if [ "$f10" = "Press F10" ]; then
    echo "sending F10"
    tput kf10  >&5
  fi
done

```
## Programming the tpm1a module

## Image
![image](https://user-images.githubusercontent.com/18163327/134554757-9f0c7839-5f78-4a8d-ad67-28006a9fbbff.png)

## Schematics
![image](https://user-images.githubusercontent.com/18163327/134555256-a5d446c7-f6f0-4c22-9d95-86398d6b7be1.png)

