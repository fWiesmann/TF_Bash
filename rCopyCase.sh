#!/bin/bash
#
#########
# Script to Copy Open Foam Case with 0, constant and system folders
#########

shopt -s expand_aliases
source ~/.bash_aliases

user_server=wiesmann
ip_server=10.50.25.24 

# Command Line Arguments must have the following format
# 1st: $1 name of Case
# 2nd: $2 Mesh index

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

# Check if case name is folder in current path
curDir=$(pwd)
if [ -d $curDir/$nameCase ]; then 
	echo "[INFO] Case exists, copying ..."; 
else
	echo "[ERROR] Case does not exist, exiting ...";
	exit
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

mesh=mesh_$meshIdx

dir_server=/home/wiesmann/simulations/of2412/512000000_SAFETY_RELIEF_VALVE_Optimization/$mesh

# Starting the copy process
echo "[INFO] Copying to case: $nameCase with mesh $mesh to Lixus Server: $user_server@$ip_server to folder: $dir_server"
rsync -e "ssh -i ~/.ssh/id_rsa" -av --info=progress2 --no-inc-recursive $nameCase $user_server@$ip_server:$dir_server/



