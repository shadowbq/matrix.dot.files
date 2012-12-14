#!/bin/bash

function randomline {

	FILERZ=$1
	NUMRZ=$(wc -l < $FILERZ)
	
	# echo "$NUMRZ"
	
	if [ $NUMRZ -gt 1000000000 ]; then
		echo 'Over 1 Billion Lines, complex selection required'
		exit 1;
		
		
	else
		# generate random number in range 0-NUM Using $RANDOM (less than 32bit unsigned)
		#let "XRZ = (RANDOM % NUMRZ) + 1"
		
		IRZ=$((`od -N4 -An -i /dev/urandom` % NUMRZ))
		XRZ=${IRZ#-}
		
		# echo "finding random line $XRZ from file ${FILERZ}"
		
		# extract XRX-th line
		if [ -z $NO_CR ]; then
			sed -n ${XRZ}P ${FILERZ}
		else
			sed -n ${XRZ}p ${FILERZ}
		fi
	fi	
}
