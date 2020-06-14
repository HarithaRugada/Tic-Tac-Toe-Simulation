#!/bin/bash -x

echo "WELCOME TO TIC TAC TOE SIMULATION"

NUMBER_OF_ROWS=3
NUMBER_OF_COLUMNS=3

flag=0
value=0

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

function changeTurn()
{
	if [ $playerTurn -eq 1 ]
	then
		playerMove
	elif [ $playerTurn -eq 2 ]
	then
		computerMove
	fi
}

function checkRow()
{
	for (( i=1; i<=$NUMBER_OF_ROWS; i++ ))
	do
		for (( j=1; j<=$NUMBER_OF_COLUMNS; ))
		do
			if [ ${board[$i,$j]} != '.' ]
			then
				if [ ${board[$i,$j]} == ${board[$i,$(( $j+1 ))]} ] && [ ${board[$i,$(( $j+1 ))]} == ${board[$i,$(( $j+2 ))]} ]
				then
					value=1
					break
				fi
			fi
		done
	if [ $value -eq 1 ]
	then
		break
	fi
	done
}

function checkColumn()
{
        for (( i=1; i<=$NUMBER_OF_COLUMNS; i++ ))
        do
                for (( j=1; j<=$NUMBER_OF_ROWS; ))
                do
                        if [ ${board[$j,$i]} != '.' ]
                        then
                                if [ ${board[$j,$i]} == ${board[$j,$(( $i+1 ))]} ] && [ ${board[$j,$(( $i+2 ))]} == ${board[$j,$i]} ]
                                then
                                        value=1
                                        break
                                fi
                        fi
                done
	if [ $value -eq 1 ]
	then
		break
	fi
        done
}

function checkDiagonal()
{
	if [ ${board[1,1]} != '.' ]
	then
		if [ ${board[1,1]} == ${board[2,2]} ] && [ ${board[2,2]} == ${board[3,3]} ]
		then
			value=1
		fi
	fi

	if [ ${board[1,3]} != '.' ]
	then
		if [ ${board[1,3]} == ${board[2,2]} ] && [ ${board[2,2]} == ${board[3,1]} ]
		then
			value=1
		fi
	fi
}

function checkTie()
{
	local tie=0
	for (( i=1; i<=$NUMBER_OF_ROWS; i++ ))
	do
		for (( j=1;j<=$NUMBER_OF_COLUMNS; j++ ))
		do
			if [ ${board[$i,$j]} != '.' ]
			then
				tie=1
				break
			fi
		done
		if [ $tie -eq 1 ]
		then
			break
		fi
	done
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
	for (( i=1; i<=$NUMBER_OF_ROWS; i++ ))
	do
		if [ $value -ne 1 ]
		then
                	for (( j=1; j<=$NUMBER_OF_COLUMNS; ))
                	do
				if [ ${board[$i,$j]} == ${board[$i,$(( $j+1 ))]} ] && [ ${board[$i,$j]} == $computerSymbol ] && [ ${board[$i,$(( $j+2 ))]} != $playerSymbol ]
				then
							board[$i,$(( $j+2 ))]=$computerSymbol
							value=1
							break
				elif [ ${board[$i,$j]} == ${board[$i,$(( $j+2 ))]} ] && [ ${board[$i,$j]} == $computerSymbol ] && [ ${board[$i,$(( $j+1 ))]} != $playerSymbol ]
				then
					board[$i,$(( $j+1 ))]=$computerSymbol
					value=1
					break
				elif [ ${board[$i,$(( $j+1 ))]} == ${board[$i,$(( $j+2 ))]} ] && [ ${board[$i,$(( $j+1 ))]} == $computerSymbol ] && [ ${board[$i,$j]} != $playerSymbol ]
				then
					board[$i,$j]=$computerSymbol
					value=1
					break
				fi
                	done
			if [ $value -eq 1 ]
			then
				break
			fi
		fi
        done
}

function setComputerSymbolToWinColumn()
{
        for (( i=1;i<=$NUMBER_OF_COLUMNS; i++ ))
        do
		if [ $value -ne 1 ]
		then
                	for (( j=1; j<=$NUMBER_OF_ROWS; ))
                	do
                		if [ ${board[$j,$i]} == ${board[$j,$(( $i+1 ))]} ] && [ ${board[$j,$(( $i+2 ))]} != $computerSymbol ]
                        	then
                        		board[$j,$(( $i+2 ))]=$computerSymbol
                     	           	value=1
                                	break
                        	elif [ ${board[$j,$i]} == ${board[$i,$(( $j+2 ))]} ] && [ ${board[$j,$(( $i+1 ))]} != $computerSymbol ]
                        	then
                        		board[$j,$(( $i+1 ))]=$computerSymbol
                        	        value=1
                        	        break
                        	elif [ ${board[$j,$(( $i+1 ))]} == ${board[$i,$(( $j+2 ))]} ] || [ ${board[$j,$i]} != $computerSymbol ]
                        	then
                        		board[$j,$i]=$computerSymbol
                                	value=1
                                	break
                        	fi
                	done
                if [ $value -eq 1 ]
                then
                        break
                fi
		fi
        done
}

function setComputerSymbolToWinDiagonal()
{
	if [ ${board[1,1]} == $computerSymbol ] && [ ${board[2,2]} == $computerSymbol ] && [ ${board[3,3]} == '.' ]
	then
		board[3,3]=$computerSymbol
		value=1
	elif [ ${board[1,1]} == $computerSymbol ] && [ ${board[3,3]} == $computerSymbol ] && [ ${board[2,2]} == '.' ]
	then
		board[2,2]=$computerSymbol
		value=1
	elif [ ${board[2,2]} == $computerSymbol ] && [ ${board[3,3]} == $computerSymbol ] && [ ${board[3,3]} == '.' ]
        then
                board[3,3]=$computerSymbol
                value=1
	elif [ ${board[1,3]} == $computerSymbol ] && [ ${board[2,2]} == $computerSymbol ] && [ ${board[3,1]} == '.' ]
        then
                board[3,1]=$computerSymbol
                value=1
	elif [ ${board[1,3]} == $computerSymbol ] && [ ${board[3,1]} == $computerSymbol ] && [ ${board[2,2]} == '.' ]
        then
                board[2,2]=$computerSymbol
                value=1
	elif [ ${board[3,1]} == $computerSymbol ] && [ ${board[2,2]} == $computerSymbol ] && [ ${board[1,3]} == '.' ]
        then
                board[1,3]=$computerSymbol
                value=1
	fi
}

function setComputerSymbolToBlockRow()
{
	for (( i=1;i<=$NUMBER_OF_ROWS; i++ ))
        do
		if [ $flag == 0 ]
		then
                	for (( j=1; j<=$NUMBER_OF_COLUMNS; ))
                	do
                		if [ ${board[$i,$j]} == ${board[$i,$(( $j+1 ))]} ] && [ ${board[$i,$j]} == $playerSymbol ] && [ ${board[$i,$(( $j+2 ))]} == '.' ]
                        	then
                        		board[$i,$(( $j+2 ))]=$computerSymbol
					flag=1
                                        break
                                elif [ ${board[$i,$j]} == ${board[$i,$(( $j+2 ))]} ] && [ ${board[$i,$j]} == $playerSymbol ] && [ ${board[$i,$(( $j+1 ))]} == '.' ]
                                then
                                        board[$i,$(( $j+1 ))]=$computerSymbol
					flag=1
                                        break
                                elif [ ${board[$i,$(( $j+1 ))]} == ${board[$i,$(( $j+2 ))]} ] && [ ${board[$i,$(( $j+1 ))]} ] && [ ${board[$i,$j]} == '.' ]
                                then
                                        board[$i,$j]=$computerSymbol
					flag=1
                                        break
                                fi
                	done
		fi
		if [ $flag ==1 ]
		then
			break
		fi
	done
}
function setComputerSymbolToBlockColumn()
{
	for (( i=1;i<=$NUMBER_OF_COLUMNS; i++ ))
	do
		if [ $flag == 0 ]
		then
	                for (( j=1; j<=$NUMBER_OF_ROWS; ))
        	        do
                                if [ ${board[$j,$i]} == ${board[$j,$(( $i+1 ))]} ] && [ ${board[$j,$i]} == $playerSymbol ] && [ ${board[$j,$(( $i+2 ))]} != $playerSymbol ]
                                then
                                        board[$j,$(( $i+2 ))]=$computerSymbol
                                        flag=1
                                        break
                                elif [ ${board[$j,$i]} == ${board[$i,$(( $j+2 ))]} ] && [ ${board[$j,$i]} == $playerSymbol ] && [ ${board[$j,$(( $i+1 ))]} != $playerSymbol ]
                                then
                                        board[$j,$(( $i+1 ))]=$computerSymbol
                                        flag=1
                                        break
                                elif [ ${board[$j,$(( $i+1 ))]} == ${board[$i,$(( $j+2 ))]} ] && [ ${board[$j,$(( $i+1 ))]} ==$playerSymbol ] && [ ${board[$j,$i]} != $playerSymbol ]
                                then
                                        board[$j,$i]=$computerSymbol
                                        flag=1
                                        break
                                fi
                        done
                fi
                if [ $flag -eq 1 ]
                then
                        break
                fi
	done
}

function setComputerSymbolToBlockDiagonal()
{
	if [ $flag == 0 ]
	then
        if [ ${board[1,1]} == $computerSymbol ] && [ ${board[2,2]} == $computerSymbol ] && [ ${board[3,3]} == '.' ]
        then
                board[3,3]=$computerSymbol
                flag=1
        elif [ ${board[1,1]} == $computerSymbol ] && [ ${board[3,3]} == $computerSymbol ] && [ ${board[2,2]} == '.' ]
        then
                board[2,2]=$computerSymbol
                flag=1
        elif [ ${board[2,2]} == $computerSymbol ] && [ ${board[3,3]} == $computerSymbol ] && [ ${board[3,3]} == '.' ]
        then
                board[3,3]=$computerSymbol
                flag=1
        elif [ ${board[1,3]} == $computerSymbol ] && [ ${board[2,2]} == $computerSymbol ] && [ ${board[3,1]} == '.' ]
        then
                board[3,1]=$computerSymbol
                flag=1
        elif [ ${board[1,3]} == $computerSymbol ] && [ ${board[3,1]} == $computerSymbol ] && [ ${board[2,2]} == '.' ]
        then
                board[2,2]=$computerSymbol
                flag=1
        elif [ ${board[3,1]} == $computerSymbol ] && [ ${board[2,2]} == $computerSymbol ] && [ ${board[1,3]} == '.' ]
        then
                board[1,3]=$computerSymbol
                flag=1
        fi
	fi
}

function occupyCorner()
{
	for (( i=1; i<=$NUMBER_OF_ROWS; i=$(( $i+2 )) ))
        do
                for (( j=1; j<=$NUMBER_OF_COLUMNS; j=$(( $j+2 )) ))
                do
                        if [ ${board[$i,$j]} = '.' ]
                        then
				board[$i,$j]=$computerSymbol
				value=1
				break
			fi
		done
		if [ $value -eq 1 ]
		then
			break
		fi
	done
}

function occupyCentre()
{
	if [ ${board[2,2]} == '.' ]
	then
		board[2,2]=$computerSymbol
		value=1
	fi
}

function occupySide()
{
	for (( i=1; i<=$NUMBER_OF_ROWS; i++ ))
        do
                for (( j=1; j<=$(( $NUMBER_OF_COLUMNS-1 )); j++ ))
                do
			if [ $(( $j-$i )) -eq 1 ] || [ $(( $i-$j )) -eq 1 ]
			then
				if [ ${board[$i,$j]} == '.' ]
				then
					board[$i,$j]=$computerSymbol
					value=1
				fi
			fi
		done
		break
	done
}

function computerWin()
{
	if [ $flag -ne 1 ]
	then
		setComputerSymbolToWinRow
		setComputerSymbolToWinColumn
		setComputerSymbolToWinDiagonal
	fi
}

function computerBlock()
{
	if [ $flag -ne 1 ]
	then
		setComputerSymbolToBlockRow
		setComputerSymbolToBlockColumn
		setComputerSymbolToBlockDiagonal
	fi
}

function computerMove()
{
	computerWin
	computerBlock
	occupyCorner
	occupyCentre
	occupySide
}

function playerMove()
{
	read -p "Enter Row > " playerRow
	read -p "Enter Column > " playerColumn
	if [ $playerRow -lt 1 ] || [ $playerRow -gt 3 ] || [ $playerColumn -lt 1 ] || [ $playerColumn -gt 3 ]
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
	resetBoard
	toss
	while [ $value -ne 1 ]
	do
		displayBoard
		changeTurn
		displayWinner
		player=$(( (( $playerTurn%2 ))+1 ))
	done
	if [ $player -eq 2 ]
	then
		echo "Player won the game"
	else
		echo "Computer won the game"
	fi
}

playGame

