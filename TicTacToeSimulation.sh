#!/bin/bash -x

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
	local letter=$(( RANDOM%2 ))
	if [ $letter -eq 1 ]
	then
		playerSymbol=X
		computerSymbol=O
	else
		playerSymbol=O
		computerSymbol=X
	fi

	echo "Player Symbol is " $playerSymbol
	echo "Player Symbol is " $computerSymbol
}

function toss()
{
	assignLetter
	read -p "Enter your choice > 1.Head  2.Tail  >  " choice
	local tossValue=$(( $(( $RANDOM%2 ))+1 ))
	if [ $tossValue -eq $choice ]
	then
		playerTurn=1
		echo "Player won the toss"
		echo "FIRST TURN"
	else
		playerTurn=2
		echo "Player lost the toss"
		echo "SECOND TURN"
	fi
}

function displayBoard()
{
	echo "  --- --- --- "
	echo " | ${board[1]} | ${board[2]} | ${board[3]} | "
	echo "  --- --- --- "
	echo " | ${board[4]} | ${board[5]} | ${board[6]} | "
	echo "  --- --- --- "
	echo " | ${board[7]} | ${board[8]} | ${board[9]} | "
	echo "  --- --- --- "
}

function checkRow()
{
	local flag1=1

	for (( position=1; position<=$TOTAL_GRIDS; position=$(( $position+3 )) ))
	do
		if [ ${board[$position]} -eq ${board[$(( $position+1 ))]} ]
		then
			if [ ${board[$position]} -eq ${board[$(( $position+1 ))]} ]
			then
				if [ ${board[$position]} -eq ${board[$(( $position+1 ))]} ]
				then
					flag1=0
				fi
			fi
		else
			flag1=1
		fi
	done

	echo $flag1
}

function checkColumn()
{
        local flag2=1

        for (( position=1; position<=$(( $TOTAL_GRIDS/3 )); position=$(( $position+3 )) ))
        do
                if [ ${board[$position]} -eq ${board[$(( $position+3 ))]} ]
                then
                        if [ ${board[$position]} -eq ${board[$(( $position+3 ))]} ]
                        then
                                if [ ${board[$position]} -eq ${board[$(( $position+3 ))]} ]
                                then
                                        flag2=0
                                fi
                        fi
                else
                        flag2=1
                fi
        done

        echo $flag2
}

function checkDiagonal()
{
	local flag3=1

	if [ ${board[1]} -eq ${board[5]} ]
	then
		if [ ${board[5]} -eq ${board[9]} ]
		then
			flag3=0
		fi

	elif [ ${board[3]} -eq ${board[5]} ]
	then
		if [ ${board[5]} -eq ${board[7]} ]
		then
			flag3=0
		fi

	else
		flag3=1
	fi

        echo $flag3
}

function isWinner()
{
	position=1
	while [ $position -le $TOTAL_GRIDS ]
	do
		resetBoard
		toss
		displayBoard
		flag1=$(checkRow)
		flag2=$(checkColumn)
		flag3=$(checkDiagonal)

		if [ $flag1 -eq 0 ]
		then
			echo "WIN"
			exit

		elif [ $flag2 -eq 0 ]
		then
			echo "WIN"
			exit

		elif [ $flag3 -eq 0 ]
		then
			echo "WIN"
			exit
		fi

		position=$(( $position+1 ))
	done
}


isWinner
