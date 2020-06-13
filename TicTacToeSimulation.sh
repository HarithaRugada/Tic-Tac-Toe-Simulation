#!/bin/bash

echo "WELCOME TO TIC TAC TOE SIMULATION"

TOTAL_GRIDS=9
NUMBER_OF_ROWS=3
NUMBER_OF_COLUMNS=3

flag=0

declare -A board

function resetBoard()
{
	for (( i=1; i<=$NUMBER_OF_ROWS; i++ ))
	do
		for (( j=1; j<=$NUMBER_OF_COLUMNS; j++  ))
		do
			board[$i,$j]='.'
		done
	done
}

function assignLetter()
{
	local letter=$(( RANDOM%2 ))

	if [ $letter -eq 1 ]
	then
		playerOneSymbol=X
		playerTwoSymbol=O
	else
		playerOneSymbol=O
		playerTwoSymbol=X
	fi

	echo "Player Symbol is " $playerOneSymbol
	echo "Computer Symbol is " $playerTwoSymbol
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
	echo " | ${board[1,1]} | ${board[1,2]} | ${board[1,3]} | "
	echo "  --- --- --- "
	echo " | ${board[2,1]} | ${board[2,2]} | ${board[2,3]} | "
	echo "  --- --- --- "
	echo " | ${board[3,1]} | ${board[3,2]} | ${board[3,3]} | "
	echo "  --- --- --- "
}


function checkRow()
{
	for (( i=1; i<=$NUMBER_OF_ROWS; i++ ))
	do
		for (( j=1; j<=$NUMBER_OF_COLUMNS; ))
		do
			if [ ${board[$i,$j]} != '.' ]
			then
				if [ ${board[$i,$j]} == ${board[$i,$(( j++ ))]} ]
				then
					flag=1
					break
				else
					flag=0
				fi
			fi
		break
		done
	done

	echo $flag
}

function checkColumn()
{
        for (( i=1; i<=$NUMBER_OF_COLUMNS; i++ ))
        do
                for (( j=1; j<=$NUMBER_OF_ROWS; ))
                do
                        if [ ${board[$i,$j]} != '.' ]
                        then
                                if [ ${board[$i,$j]} == ${board[$i,$(( j++ ))]} ]
                                then
                                        flag=1
                                        break
                                else
                                        flag=0
                                fi
                        fi
                break
                done
        done

        echo $flag
}

function checkDiagonal()
{
	if [ ${board[1]} == ${board[5]} ]
	then
		if [ ${board[5]} == ${board[9]} ]
		then
			flag=1
		fi

	elif [ ${board[3]} == ${board[5]} ]
	then
		if [ ${board[5]} == ${board[7]} ]
		then
			flag=1
		fi

	else
		flag=0
	fi

        echo $flag
}

function checkTie()
{
	local tie=1
	for (( i=1; i<=$NUMBER_OF_ROWS; i++ ))
	do
		for (( j=1;j<=$NUMBER_OF_COLUMNS; j++ ))
		do
			if [ ${board[$i,$j]} == '.' ]
			then
				tie=0
				break
			fi
		done
	done
}
function checkWin()
{
	if [ $(checkRow) -eq 1 ]
	then
		echo $(checkRow)
	elif [ $(checkColumn) -eq 1 ]
	then
		echo $(checkColumn)
	elif [ $(checkDiagonal) -eq 1 ]
	then
		echo $(checkDiagonal)
	else
		echo
	fi
}

function displayWinner()
{
	if [ $(checkWin) -eq 1 ]
	then
		echo "WON"
	elif [ $(checkTie) -eq 1 ]
	then
		echo "TIE"
	else
		echo "Next Turn"
	fi
}

function setComputerSymbolForWin()
{
	for (( i=1;i<=$NUMBER_OF_ROWS; i++ ))
	do
                for (( j=1; j<=$NUMBER_OF_COLUMNS; j++ ))
                do
                        if [ ${board[$i,$j]} != '.' ]
                        then
				${board[$i,$j]}=$computerSymbol
				break
                        fi
                done
        done
}

function setComputerSymbolForBlock()
{
	for (( i=1; i<=$NUMBER_OF_ROWS; i++ ))
	do
		for (( j=1; j<=$NUMBER_OF_COLUMNS; j++ ))
		do
			if [ ${board[$i,$j]} != '.' ]
			then
				${board[$i,$j]}=$playerSymbol
				if [ $(checkWin) -eq 1 ]
				then
					${board[$i,$j]}=$computerSymbol
				fi
			fi
		done
	done
}

function setSymbol()
{
	if [ $flag -eq 1 ]
	then
		setComputerSymbolForWin
	else
		setComputerSymbolForBlock
	fi
}

function playForWin()
{
	checkRow
	setSymbol
	checkColumn
	setSymbol
	checkDiagonal
	setSymbol
}

resetBoard
toss
playForWin
