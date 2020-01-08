#!/usr/bin/env bash

function alphalower() {
  randomBetween 97 122 1
  if [ -z $NO_CR ]; then
    echo -n "${randomBetweenAnswer}" | awk '{printf "%c\n", $1}'
  else
    echo -n "${randomBetweenAnswer}" | awk '{printf "%c", $1}'
  fi
}

function alphaupper() {
  randomBetween 65 90 1
  if [ -z $NO_CR ]; then
    echo -n "${randomBetweenAnswer}" | awk '{printf "%c\n", $1}'
  else
    echo -n "${randomBetweenAnswer}" | awk '{printf "%c", $1}'
  fi
}

function lorumipsum() {
  grep -E --binary-files=text -o [[:alnum:]\ ] </dev/urandom | fmt | tr 0-9 '@ \n' | sed 's/ //g' | grep -v ^$ | tr '@' ' \n' | sed 's/^ .*//' | fmt
}
