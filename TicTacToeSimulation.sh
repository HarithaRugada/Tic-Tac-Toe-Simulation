#!/bin/bash

echo "WELCOME TO TIC TAC TOE SIMULATION"

TOTAL_GRIDS=9

declare -A board

function resetBoard()
{
	for (( position=1; position<=$TOTAL_GRIDS; position++ ))
	do
		board[$position]=$position
	done
}

function assignLetter()
{
	letter=$(( RANDOM%2 ))
	if [ $letter -eq 1 ]
	then
		echo " Assigned Letter = X "
	else
		echo " Assigned Letter = O "
	fi
}

function toss()
{
	assignLetter
	read -p "Enter your choice > 1.Head  2.Tail  >  " choice
	tossValue=$(( $(( $RANDOM%2 ))+1 ))
	if [ $tossValue -eq $choice ]
	then
		echo "Player won the toss"
		echo "FIRST TURN"
	else
		echo "Player lost the toss"
		echo "SECOND TURN"
	fi
}

toss
