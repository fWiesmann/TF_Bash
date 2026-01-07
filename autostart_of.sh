#!/bin/bash
#
#########
# Script to Autostart a Open Foam calc with automatic assignment of cores and solver
#########

shopt -s expand_aliases
source ~/.bash_aliases


# Command Line Arguments must have the following format
# 1st: $1 numCores
# 2nd: $2 solver

# Specify a limit of cores to be unsed
maxNumCoresLimit=12

default_solver="sonicFoam"

# 1st command line arg is number of cores
numCores=$1
if [ -z "$numCores" ]; then
        # Ask for numCores
        echo [INFO] No number of cores given: Enter now or leave epmty for default of 24
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


# 2nd command line arg is Open Foam Solver
solver=$2
if [ -z "$solver" ]; then
        # Ask for solver
	echo [INFO] No name for solver given: Enter now or leave epmty for standard solver "(=sonicFoam)"
        read -p 'Enter solver to use: ' solver
        if [ -z "$solver" ]; then
			solver=$default_solver
        fi
fi

# Activating standard Open Foam version
of2006

# Starting the solver
mpirun -np $numCores $solver -parallel > log_mpi.$solver &

