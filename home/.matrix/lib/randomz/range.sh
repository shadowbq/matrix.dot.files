#!/usr/bin/env bash

function rangewrapper() {
  randomBetween $1 $2 $3

  if [ -z $NO_CR ]; then
    echo ${randomBetweenAnswer}
  else
    echo -n ${randomBetweenAnswer}
  fi
}

function randomwrapper() {
  if [ -z $NO_CR ]; then
    echo ${RANDOM}
  else
    echo -n ${RANDOM}
  fi
}

function urandomwrapper() {
  if [ -z $NO_CR ]; then
    echo $(od -vAn -N4 -tu4 </dev/urandom | awk '{printf "%s\n", $1}' | tr -d "\n")
  else
    od -vAn -N4 -tu4 </dev/urandom | awk '{printf $1}'
  fi
}

function urandombelow() {

  IRZ=$(($(od -N4 -An -i /dev/urandom) % $1))
  XRZ=${IRZ#-}
  if [ -z $NO_CR ]; then
    echo $XRZ
  else
    echo -n $XRZ
  fi
}
