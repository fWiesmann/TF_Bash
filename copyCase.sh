#!/bin/bash
#
#########
# Script to Copy Open Foam Case with 0, constant and system folders
#########

shopt -s expand_aliases
source ~/.bash_aliases


# Command Line Arguments must have the following format
# 1st: $1 name Original Case
# 2nd: $2 name of New case

default_name="new_case"

# 1st command line arg is original case name
nameOrigCase=$1
if [ -z "$nameOrigCase" ]; then
        # Ask for nameOrigCase
        echo [INFO] No orignial case name given: Enter now 
        read -p 'Enter number of cores to use: ' nameOrigCase
        if [ -z "$nameOrigCase" ]; then
		exit
        fi
fi

# Check if case name is folder in current path
curDir=$(pwd)
if [ -d $curDir/$nameOrigCase ]; then 
	echo "[INFO] Original Case exists, copying ..."; 
else
	echo "[ERROR] Original Case does not exist, exiting ...";
	exit
fi

# 2nd command line arg is new case name
nameNewCase=$2
if [ -z "$nameNewCase" ]; then
        # Ask for nameNewCase
	echo [INFO] No name for new case given: Enter now or leave epmty for standard solver "(=new_case)"
        read -p 'Enter solver to use: ' nameNewCase
        if [ -z "$nameNewCase" ]; then
			nameNewCase=$default_name
        fi
fi

# Starting the copy process
echo "[INFO] Copying to new case name: $nameNewCase"
mkdir $nameNewCase
cp -r $nameOrigCase/0 $nameNewCase/
cp -r $nameOrigCase/constant $nameNewCase/
cp -r $nameOrigCase/system $nameNewCase/

cp -r $nameOrigCase/*.pvsm $nameNewCase/
touch $nameNewCase/$nameNewCase.foam


