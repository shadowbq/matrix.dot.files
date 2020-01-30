#!/usr/bin/env bash
#
# This is a very simple template for shell scripts. It sets sane defaults for
# execution parameters and has boilerplate code for stuff common to most
# scripts.

# References
# https://web.archive.org/web/20180825140830/http://abhipandey.com/2016/03/getopt-vs-getopts/
# https://web.archive.org/web/20181102031652/https://sookocheff.com/post/bash/parsing-bash-script-arguments-with-shopts/

# Set execution parameters:
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: the return value of a pipeline is the status of the last
#              command to exit with a non-zero status, or zero if no command
#              exited with a non-zero status
set -euo pipefail

function usage() {
      echo "Usage $(basename ${0}):"
      echo "    -a                    command with a option true."
      echo "    -b value              comand with b arg set to 'value'."
      exit 1
}

[ $# -eq 0 ] && usage

# Command-line argument parsing is done here:
# default args are '-a', '-b ARG'
_GETOPTS="ab:"

# set the default argument values here
ARG_A=false
ARG_B="defaults for -b"

# set
while getopts "${_GETOPTS}" opts; do
    case "${opts}" in
        a)
            ARG_A=true
            ;;
        b)
            ARG_B="${OPTARG}"
            ;;
        : )
            echo "Invalid option: ${OPTARG} requires an argument" 1>&2
            ;;
        [h?] | * )
            usage
            ;;    
    esac
done

echo "$ARG_A"
echo "$ARG_B"

shift $((OPTIND-1))

echo "Remaining arguments:"
for arg; do 
    echo '--> '"\`$arg'" ; 
done