#!/bin/bash

echo "WELCOME TO TIC TAC TOE SIMULATION"

TOTAL_GRIDS=9
NUMBER_OF_ROWS=3
NUMBER_OF_COLUMNS=3
TRUE=1
FALSE=0

flag=$FALSE
value=$FALSE

declare -A board

function resetBoard()
{
	for (( i=$TRUE; i<=$NUMBER_OF_ROWS; i++ ))
	do
		for (( j=$TRUE; j<=$NUMBER_OF_COLUMNS; j++  ))
		do
			board[$i,$j]='.'
		done
	done
}

function assignLetter()
{
	local letter=$(( RANDOM%2 ))

	if [ $letter -eq $TRUE ]
	then
		playerSymbol=X
		computerSymbol=O
	else
		playerSymbol=O
		computerSymbol=X
	fi

	echo "Player Symbol is " $playerSymbol
	echo "Computer Symbol is " $computerSymbol
}

function toss()
{
	assignLetter
	read -p "Enter your choice > 1.Head  2.Tail  >  " choice
	local tossValue=$(( $(( $RANDOM%2 ))+$TRUE ))
	if [ $tossValue -eq $choice ]
	then
		playerTurn=$TRUE
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

function changeTurn()
{
	if [ $playerTurn -eq $TRUE ]
	then
		playerMove
	elif [ $playerTurn -eq 2 ]
	then
		computerMove
	fi
}

function checkRow()
{
	for (( i=$TRUE; i<=$NUMBER_OF_ROWS; i++ ))
	do
		if [ $value -eq $FALSE ]
		then
		j=$TRUE
		if [ ${board[$i,$j]} != "." ] && [ ${board[$i,$j]} == ${board[$i,$(( $j+1 ))]} ] && [ ${board[$i,$(( $j+1 ))]} == ${board[$i,$(( $j+2 ))]} ]
		then
			value=$TRUE
			checkWinner
			break
		fi
		fi
	done
}

function checkColumn()
{
        for (( i=$TRUE; i<=$NUMBER_OF_COLUMNS; i++ ))
        do
		if [ $value -eq $FALSE ]
		then
        	j=$TRUE
                if [ ${board[$j,$i]} != "." ] && [ ${board[$j,$i]} == ${board[$(( $j+1 )),$i]} ] && [ ${board[$(( $j+1 )),$i]} == ${board[$(( $j+2 )),$i]} ]
                then
	                value=$TRUE
			checkWinner
			break
                fi
		fi
        done
}

function checkDiagonal()
{
	if [ ${board[1,1]} != "." ] && [ ${board[1,1]} == ${board[2,2]} ] && [ ${board[2,2]} == ${board[3,3]} ]
	then
		i=$TRUE
		j=$TRUE
		value=$TRUE
		checkWinner
	elif [ ${board[1,3]} != "." ] && [ ${board[1,3]} == ${board[2,2]} ] && [ ${board[2,2]} == ${board[3,1]} ]
	then
		i=$TRUE
		j=3
		value=$TRUE
		checkWinner
	fi
}

function checkTie()
{
	tie=$FALSE
	for (( i=$TRUE; i<=$NUMBER_OF_ROWS; i++ ))
	do
		for (( j=$TRUE;j<=$NUMBER_OF_COLUMNS; j++ ))
		do
			if [ ${board[$i,$j]} != '.' ]
			then
				tie=$(( $tie+$TRUE ))
				if [ $tie -eq $TOTAL_GRIDS ]
				then
					echo "TIE"
					break
				fi
			fi
		done
		if [ $tie -eq $TOTAL_GRIDS ]
		then
			break
		fi
	done
}

function checkWinner()
{
	if [ ${board[$i,$j]} == $computerSymbol ]
	then
		echo "computer won"
	elif [ ${board[$i,$j]} == $playerSymbol ]
	then
		echo "player won"
	fi
}
function displayWinner()
{
	checkTie
	checkRow
	checkColumn
	checkDiagonal
}

function setComputerSymbolToWinRow()
{
	for (( i=$TRUE; i<=$NUMBER_OF_ROWS; i++ ))
	do
		if [ $flag -ne $TRUE ]
		then
			j=$TRUE
			if [ ${board[$i,$j]} == $computerSymbol ] && [ ${board[$i,$(( $j+1 ))]} == $computerSymbol ] && [ ${board[$i,$(( $j+2 ))]} == "." ]
			then
				board[$i,$(( $j+2 ))]=$computerSymbol
				flag=$TRUE
			elif [ ${board[$i,$j]} == $computerSymbol ] && [ ${board[$i,$(( $j+1 ))]} == "." ] && [ ${board[$i,$(( $j+2 ))]} == $computerSymbol ]
			then
				board[$i,$(( $j+1 ))]=$computerSymbol
				flag=$TRUE
			elif [ ${board[$i,$j]} == "." ] && [ ${board[$i,$(( $j+1 ))]} == $computerSymbol ] && [ ${board[$i,$(( $j+2 ))]} == $computerSymbol ]
			then
				board[$i,$j]=$computerSymbol
				flag=$TRUE
			fi
	fi
        done
}

function setComputerSymbolToWinColumn()
{
        for (( i=$TRUE;i<=$NUMBER_OF_COLUMNS; i++ ))
        do
		if [ $flag -ne $TRUE ]
		then
            		j=$TRUE
                	if [ ${board[$j,$i]} == $computerSymbol ] && [ ${board[$(( $j+1 )),$i]} == $computerSymbol ] && [ ${board[$(( $j+2 )),$i]} == "." ]
                        then
                                board[$(( $j+2 )),$i]=$computerSymbol
                                flag=$TRUE
                        elif [ ${board[$j,$i]} == $computerSymbol ] && [ ${board[$(( $j+1 )),$i]} == "." ] && [ ${board[$(( $j+2 )),$i]} == $computerSymbol ]
                        then
                                board[$(( $j+1 )),$i]=$computerSymbol
                                flag=$TRUE
                        elif [ ${board[$j,$i]} == "." ] && [ ${board[$(( $j+1 )),$i]} == $computerSymbol ] && [ ${board[$(( $j+2 )),$i]} == $computerSymbol ]
                        then
                                board[$j,$i]=$computerSymbol
                                flag=$TRUE
                        fi
		fi
        done
}

function setComputerSymbolToDiagonal()
{
	if [ ${board[3,3]} == '.' ]
	then
		if [ ${board[1,1]} == $1 ] && [ ${board[2,2]} == $1 ]
		then
			board[3,3]=$2
			flag=$TRUE
		fi
	elif [ ${board[2,2]} == '.' ]
	then
		if [ ${board[1,1]} == $1 ] && [ ${board[3,3]} == $1 ]
		then
			board[2,2]=$2
			flag=$TRUE
		fi
	elif [ ${board[1,1]} == '.' ]
	then
		if [ ${board[2,2]} == $1 ] && [ ${board[3,3]} == $1 ]
        	then
                	board[1,1]=$2
                	flag=$TRUE
		fi
	elif [ ${board[3,1]} == '.' ]
	then
		if [ ${board[1,3]} == $1 ] && [ ${board[2,2]} == $1 ]
        	then
                	board[3,1]=$2
                	flag=$TRUE
		fi
	elif [ ${board[2,2]} == '.' ]
	then
		if [ ${board[1,3]} == $1 ] && [ ${board[3,1]} == $1 ]
        	then
                	board[2,2]=$2
                	flag=$TRUE
		fi
	elif [ ${board[1,3]} == '.' ]
	then
		if [ ${board[3,1]} == $1 ] && [ ${board[2,2]} == $1 ]
        	then
                	board[1,3]=$2
                	flag=$TRUE
		fi
	fi
}

function setComputerSymbolToBlockRow()
{
	for (( i=$TRUE;i<=$NUMBER_OF_ROWS; i++ ))
        do
		if [ $flag == $FALSE ]
		then
                	j=$TRUE
               		if [ ${board[$i,$j]} == $playerSymbol ] && [ ${board[$i,$(( $j+1 ))]} == $playerSymbol ] && [ ${board[$i,$(( $j+2 ))]} == "." ]
                        then
                                board[$i,$(( $j+2 ))]=$computerSymbol
                                flag=$TRUE
                        elif [ ${board[$i,$j]} == $playerSymbol ] && [ ${board[$i,$(( $j+1 ))]} == "." ] && [ ${board[$i,$(( $j+2 ))]} == $playerSymbol ]
                        then
                                board[$i,$(( $j+1 ))]=$computerSymbol
                                flag=$TRUE
                        elif [ ${board[$i,$j]} == "." ] && [ ${board[$i,$(( $j+1 ))]} == $playerSymbol ] && [ ${board[$i,$(( $j+2 ))]} == $playerSymbol ]
                        then
                                board[$i,$j]=$computerSymbol
                                flag=$TRUE
                        fi

		fi
	done
}
function setComputerSymbolToBlockColumn()
{
	for (( i=$TRUE;i<=$NUMBER_OF_COLUMNS; i++ ))
	do
		if [ $flag == $FALSE ]
		then
	            	j=$TRUE
                        if [ ${board[$j,$i]} == $playerSymbol ] && [ ${board[$(( $j+1 )),$i]} == $playerSymbol ] && [ ${board[$(( $j+2 )),$i]} == "." ]
                        then
                                board[$(( $j+2 )),$i]=$computerSymbol
                                flag=$TRUE
                        elif [ ${board[$j,$i]} == $playerSymbol ] && [ ${board[$(( $j+1 )),$i]} == "." ] && [ ${board[$(( $j+2 )),$i]} == $playerSymbol ]
                        then
                                board[$(( $j+1 )),$i]=$computerSymbol
                                flag=$TRUE
                        elif [ ${board[$j,$i]} == "." ] && [ ${board[$(( $j+1 )),$i]} == $playerSymbol ] && [ ${board[$(( $j+2 )),$i]} == $playerSymbol ]
                        then
                                board[$j,$i]=$computerSymbol
                                flag=$TRUE
                        fi

                fi
	done
}

function occupyCorner()
{
	for (( i=$TRUE; i<=$NUMBER_OF_ROWS; i=$(( $i+2 )) ))
        do
		if [ $flag -eq $FALSE ]
		then
                for (( j=$TRUE; j<=$NUMBER_OF_COLUMNS; j=$(( $j+2 )) ))
                do
                        if [ ${board[$i,$j]} = '.' ]
                        then
				board[$i,$j]=$computerSymbol
				flag=$TRUE
				break
			fi
		done
		fi
	if [ $flag -eq $TRUE ]
	then
		break
	fi
	done
}

function occupyCentre()
{
	if [ $flag -eq $FALSE ]
	then
	if [ ${board[2,2]} == '.' ]
	then
		board[2,2]=$computerSymbol
		flag=$TRUE
	fi
	fi
}

function occupySide()
{
	for (( i=$TRUE; i<=$NUMBER_OF_ROWS; i++ ))
        do
		if [ $flag -eq $FALSE ]
		then
                for (( j=$TRUE; j<=$(( $NUMBER_OF_COLUMNS-1 )); j++ ))
                do
			if [ $(( $j-$i )) -eq $TRUE ] || [ $(( $i-$j )) -eq $TRUE ]
			then
				if [ ${board[$i,$j]} == '.' ]
				then
					board[$i,$j]=$computerSymbol
					flag=$TRUE
				fi
			fi
		done
		fi
	done
}

function computerWin()
{
		setComputerSymbolToWinRow
		setComputerSymbolToWinColumn
		setComputerSymbolToDiagonal $computerSymbol $computerSymbol
}

function computerBlock()
{
		setComputerSymbolToBlockRow
		setComputerSymbolToBlockColumn
		setComputerSymbolToDiagonal $playerSymbol $computerSymbol
}

function computerMove()
{
	flag=$FALSE
	computerWin
	computerBlock
	occupyCorner
	occupyCentre
	occupySide
	displayBoard
	displayWinner
	checkTie
	if [ $tie != $TOTAL_GRIDS ] && [ $value == $FALSE ]
	then
		playerMove
	fi
}

function playerMove()
{
	read -p "Enter Row > " playerRow
	read -p "Enter Column > " playerColumn
	if [ $playerRow -lt $TRUE ] || [ $playerRow -gt 3 ] || [ $playerColumn -lt $TRUE ] || [ $playerColumn -gt 3 ]
	then
		echo "Invalid Move"
		playerMove
	elif [ ${board[$playerRow,$playerColumn]} == '.' ]
	then
		board[$playerRow,$playerColumn]=$playerSymbol
		displayBoard
		computerMove
	else
		echo "Board is occupied"
		playerMove
	fi
}

function playGame()
{
	tie=$FALSE
	resetBoard
	toss
	while [ $value == $FALSE ] && [ $tie != $TOTAL_GRIDS ]
	do
		displayBoard
		changeTurn
		displayWinner
		player=$(( (( $playerTurn%2 ))+$TRUE ))
	done
}

playGame
