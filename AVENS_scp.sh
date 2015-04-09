#!/bin/bash


#to edit the script comment out your name and change the file name after /home/pi/pd to your own name and run from command line terminal
#The file also has to be made executable using the chmod +x AVENS_scp.sh (while in the same folder as the script)
#to run me type ./AVENS_scp.sh in terminal while within the same folder

$composition_name = "nathan_pulses.pd"

clear

#Clay
#echo "scp /home/pi/pd/nathan_pulses.pd pi@10.1.101:/home/pi/pd"
#echo "r"
#Elizabeth  
#echo "scp /home/pi/pd/nathan_pulses.pd pi@10.1.201:/home/pi/pd"
#echo "r"
#Mint
#echo "scp /home/pi/pd/nathan_pulses.pd pi@10.1.202:/home/pi/pd"
#echo "r"
#Davy
#echo "scp /home/pi/pd/nathan_pulses.pd pi@10.1.203:/home/pi/pd"
#echo "r"
#Jason
#echo "scp /home/pi/pd/nathan_pulses.pd pi@10.1.204:/home/pi/pd"
#echo "r"
#Ryan
#echo "scp /home/pi/pd/nathan_pulses.pd pi@10.1.205:/home/pi/pd"
#echo "r"
#Nathan
echo "scp /home/pi/pd/$composition_name pi@10.1.207:/home/pi/pd"
echo "r"
#Martin
#echo "scp /home/pi/pd/nathan_pulses.pd pi@10.1.207:/home/pi/pd"
#echo "r"
