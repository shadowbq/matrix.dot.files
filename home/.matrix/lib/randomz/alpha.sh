#!/usr/bin/env bash

function alphalower {
	randomBetween 97 122 1
	if [ -z $NO_CR ]; then 
		echo -n "${randomBetweenAnswer}" | awk '{printf "%c\n", $1}'
	else
		echo -n "${randomBetweenAnswer}" | awk '{printf "%c", $1}'
	fi
}

function alphaupper {
	randomBetween 65 90 1
	if [ -z $NO_CR ]; then 
        	echo -n "${randomBetweenAnswer}" | awk '{printf "%c\n", $1}'
	else
        	echo -n "${randomBetweenAnswer}" | awk '{printf "%c", $1}'
	fi
}

function lorumipsum {
	grep -E --binary-files=text -o [[:alnum:]\ ] < /dev/urandom | tr 0-9 ' \n' | fmt |grep -v ^$ | sed 's/ //g' |fmt
}