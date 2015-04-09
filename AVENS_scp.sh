#!/bin/bash

#   To use follow the following steps
#
#first download sshpass, on the pi this can be done by typing "sudo apt-get install sshpass" into the command line
#
#Next comment out the line after your name as you dont need to send the file to yourself
#
#enter in the name of the file you want to transfer inbetween the quotes after composition_name
#
#
#This file has to be made executable by typing "chmod u+rwx AVENS_scp.sh" in the command line from within the folder that this file is kept

#Thats it your good to go!

#to run me type ./AVENS_scp.sh in terminal while within the same folder

composition_name=""

#Clay
sshpass -p "r" scp  /home/pi/pd/$composition_name pi@10.0.1.101:/home/pi/pd
#Elizabeth  
sshpass -p "r" scp  /home/pi/pd/$composition_name pi@10.0.1.201:/home/pi/pd
#Mint
sshpass -p "r" scp  /home/pi/pd/$composition_name pi@10.0.1.202:/home/pi/pd
#Davy
sshpass -p "r" scp  /home/pi/pd/$composition_name pi@10.0.1.203:/home/pi/pd
#Jason
sshpass -p "r" scp  /home/pi/pd/$composition_name pi@10.0.1.204:/home/pi/pd
#Ryan
sshpass -p "r" scp  /home/pi/pd/$composition_name pi@10.0.1.205:/home/pi/pd
#Nathan
sshpass -p "r" scp  /home/pi/pd/$composition_name pi@10.0.1.206:/home/pi/pd
#Martin
sshpass -p "r" scp  /home/pi/pd/$composition_name pi@10.0.1.207:/home/pi/pd
