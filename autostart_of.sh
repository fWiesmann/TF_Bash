#!/bin/bash
#
#########
# Script to Autostart a Open Foam calc with automatic assignment of cores and solver
#########

shopt -s expand_aliases
source ~/.bash_aliases


# Command Line Arguments must have the following format
# 1st: $1 ofVersion
# 2nd: $2 reStart
# 3rd: $3 numCores
# 4th: $4 solver


## Default values for parameters

# Default Open Foam Version
default_ofVersion="of2006"

# Specify a default limit of cores to be used
maxNumCoresLimit=12  

default_solver="sonicFoam"

default_reStart="0"

# 1st command line arg is version of open foam/ foam extend to be used
ofVersion=$1
if [ -z "$ofVersion" ]; then
        # Ask for Open Foam Version
        echo [INFO] No name for Open Foam / Foam Extend version given: Enter now or leave epmty for standard version "(=of2006)"
        read -p 'Enter solver to use: ' ofVersion
        if [ -z "$ofVersion" ]; then
                        ofVersion=$default_ofVersion
        fi
fi

# 2nd command line arg is restart option
reStart=$2
if [ -z "$reStart" ]; then
        # Ask for solver
        echo [INFO] No entry for re-start option given: Enter now or leave empty for standard start "(=0)"
	read -p 'Enter 0(=normal start)  or 1(=re-start): ' reStart
        if [ -z "$reStart" ]; then
                        reStart=$default_reStart
        fi
fi

# 3rd command line arg is number of cores
numCores=$3
if [ -z "$numCores" ]; then
        # Ask for numCores
        echo [INFO] No number of cores given: Enter now or leave empty for default of 24
        read -p 'Enter number of cores to use: ' numCores
        if [ -z "$numCores" ]; then
		numCores=$maxNumCoresLimit
        fi
fi

# Check if max num cores avail does not exceed limit
if [ $numCores -gt $maxNumCoresLimit ]; then
	echo [INFO] Number of cores given is greater than maximum: Setting to limit of $maxNumCoresLimit
	numCores=$maxNumCoresLimit
fi


# 4th command line arg is Open Foam Solver
solver=$4
if [ -z "$solver" ]; then
        # Ask for solver
	echo [INFO] No name for solver given: Enter now or leave empty for standard solver "(=sonicFoam)"
        read -p 'Enter solver to use: ' solver
        if [ -z "$solver" ]; then
			solver=$default_solver
        fi
fi


# Activating standard Open Foam / Foam Extend version
echo [INFO] Activating Open Foam / Foam Extend Version: "$ofVersion"
if [ "$ofVersion" = "of2006" ]; then
	of2006
elif [ "$ofVersion" = "of2412" ]; then	
	of2412
elif [ "$ofVersion" = "fe41" ]; then	
	fe41
elif [ "$ofVersion" = "fe50" ]; then	
	fe50
else
	echo [WaRNING] Given Ooen Foam Version not Found: Activating Default Open Foam Version: "$default_ofVersion"
	of2006
fi

# Starting the solver
if [ $reStart -eq 0 ]; then
	# Standard Start up from time = 0 --> New log file!
	mpirun -np $numCores $solver -parallel > log_mpi.$solver 2>&1
else
	# Re-starting from latest time written out --> Append log!
	mpirun -np $numCores $solver -parallel >> log_mpi.$solver 2>&1
fi

