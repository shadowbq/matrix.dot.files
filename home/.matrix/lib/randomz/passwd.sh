#!/usr/bin/env bash

## Should use apg if available
## http://linux.die.net/man/1/apg

function randpw() {
  tr </dev/urandom -dc _A-Z-a-z-0-9 | head -c${1:-16}
  echo
}

function randpw_special() {
  tr </dev/urandom -dc _A-Z-a-z-0-9\\{}\;:_\- | head -c${1:-16}
  echo
}

randpw
