#!/usr/bin/env bash

randpw(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;}

randpw_special(){ < /dev/urandom tr -dc _A-Z-a-z-0-9\\{}\;:_\- | head -c${1:-16};echo;}

randpw
