#!/bin/bash
#
#########
# Script to sync Open Foam Simulation time
#########

shopt -s expand_aliases
source ~/.bash_aliases

user_server=wiesmann
ip_server=10.50.25.24 

# Command Line Arguments must have the following format
# 1st: $1 name of Case
# 2nd: $2 Mesh index
# 3rd: $3 Time

default_mesh="2b"

# 1st command line arg is case name
nameCase=$1
if [ -z "$nameCase" ]; then
        # Ask for nameOrigCase
        echo [INFO] No case name given: Enter now 
        read -p 'Enter name of case to use: ' nameCase
        if [ -z "$nameCase" ]; then
		exit
        fi
fi


# 2nd command line arg is index of mesh
meshIdx=$2
if [ -z "$meshIdx" ]; then
        # Ask for Mesh Index
	echo [INFO] No mesh index [1a, ..., 4a] given: Enter now or leave epmty for default "(=2b)"
        read -p 'Enter mesh index to use: ' meshIdx
        if [ -z "$meshIdx" ]; then
			meshIdx=$default_mesh
        fi
fi

# 3rd command line arg is Simulaton 
time=$3
if [ -z "$time" ]; then
        # Ask for time
	echo [INFO] No time given: Enter now or leave epmty for exit
        read -p 'Enter time to sync: ' time
        if [ -z "$time" ]; then
			exit
        fi
fi


mesh=mesh_$meshIdx

dir_local=/mnt/c/Users/f_wiesmann/Documents/simulations/of2006/512000000_SAFETY_RELIEF_VALVE_Optimization/$mesh
dir_server=/home/wiesmann/simulations/of2412/512000000_SAFETY_RELIEF_VALVE_Optimization/$mesh

# Check if case name is folder in current path

if [ -d $dir_local/$nameCase ]; then 
	echo "[INFO] Case exists, copying ..."; 
else
	echo "[ERROR] Case does not exist, exiting ...";
	exit
fi

# Starting the copy process
echo "[INFO] Copying Sim Time $time to case: $nameCase with mesh $mesh from Lixus Server: $user_server@$ip_server and folder: $dir_server"
rsync -e "ssh -i ~/.ssh/id_rsa" -av --info=progress2 --no-inc-recursive $user_server@$ip_server:$dir_server/$nameCase/$time $dir_local/$nameCase/



