#!/bin/bash
CHECKER=$(stat test.html | grep -i modify | cut -d' ' -f3 | cut -d':' -f1)
HOUR=$(date +%H)
DAY_CHECKER=$(head -n 1 test.txt)

#checks whether it has been more than an hour or if it has been a new day
if [[ $CHECKER -lt $HOUR || $DAY_CHECKER != $(date +%D) || ! -e test.html ]]; then
	wget -q -O test.html "https://twitter.com/FunkoPopHunters"
	echo checking	

	#this is for searching instances of my favorite pop
POP=$(grep -i "$(cat favoritePops.txt)" test.html  | grep 'data-aria-label-part="0">' | cut -d '>' -f2 | cut -d '<' -f1| cat -n)
	#this is for grabbing the image link 
LINK=$(grep -i "$(cat favoritePops.txt)" test.html | grep '>pic.twitter' | sed 's/^.*pic/pic/' | cut -d '<' -f1 | cat -n)

	#if the link is not an image check for a restock link
	if [[ -z $LINK ]]; then 
		LINK=$(grep -i "$(cat favoritePops.txt)" test.html  | grep 'data-expanded-url' | grep href | cut -d '<' -f3 | cut -d '"' -f2 | cut -b 9- | cat -n)
	fi

	#if there are no pops 
	if [[ -z $POP ]]; then 
		echo "There isn't any pops dude"
	else
		echo "Refreshed"
		echo $(date +%D) | tee test.txt
		echo "Pop Names" | tee -a test.txt
		echo "------------------------------" | tee -a test.txt
		echo "$POP" | tee -a test.txt
		echo "------------------------------" | tee -a test.txt
		echo "Corresponding Images/Links" | tee -a test.txt
		echo "------------------------------" | tee -a test.txt
		echo "$LINK" | tee -a test.txt
		echo "------------------------------" | tee -a test.txt
		echo 
		echo "Which Image/Link would you like to launch (choose a number, 0 to exit):"
		read -r CHOICE
	
		if [[ $CHOICE -eq 0 || -z $CHOICE ]]; then 
			exit 0;
		fi
	fi 
	#launch windows subshell to launch chrome 
		cmd.exe /C start http://"$(grep -A 20 "Corresp" test.txt | grep "\s$CHOICE" | cut -d "$CHOICE" -f2| tr -d '[:space:]')" 
else 
	cat test.txt
	
	echo "Which Image/Link would you like to launch (choose a number, 0 to exit):"
	read -r CHOICE	
	
	if [[ $CHOICE -eq 0 || -z $CHOICE ]]; then 
		exit 0;		
	fi 
	
	#launch windows subshell to launch chrome 
	cmd.exe /C start http://"$(grep -A 20 "Corresp" test.txt | grep "\s$CHOICE" | cut -d "$CHOICE" -f2| tr -d '[:space:]')" 
fi