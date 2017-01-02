#!/bin/bash

###### hostnames is extracted in single file

ssh server-1 hostname > vmlist.txt
ssh server-2 hostname >> vmlist.txt
ssh server-3 hostname >> vmlist.txt

###### hostnames (comma separated) 

awk -v ORS=, '{print $1}' vmlist.txt | sed 's/,$//'
echo -e "\n"

awk -v ORS=, '{print $1}' vmlist.txt | sed 's/,$//' > hostnames

###### defining variable for hostname

hostname1=$(awk -F',' '{print $1}' hostnames)
hostname2=$(awk -F',' '{print $2}' hostnames)
hostname3=$(awk -F',' '{print $3}' hostnames)

#### Copy hostnmaes in pssh-hosts file

cp vmlist.txt pssh-hosts

#### Install Parallel SSH packake if not installed

dpkg -l | grep pssh > /dev/null
if [ "$?" -eq "1" ];then
apt-get install python-pip
pip install python-pip
fi

#### Will ask for single prompt to user 
echo -e "\n"
echo "Please enter the command:"
read fcommand

#### Using Parallel SSH to execute the command

parallel-ssh -h pssh-hosts -l root -i "$fcommand"
