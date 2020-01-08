# shellcheck shell=bash

function reseed() {
  SEED=$(head -1 /dev/urandom | od -N 1 | awk '{ print $2 }')
  RANDOM=$SEED
}
