#!/usr/bin/env bash
#
# This is a very simple template for shell scripts. It sets sane defaults for
# execution parameters and has boilerplate code for stuff common to most
# scripts.

# Set execution parameters:
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: the return value of a pipeline is the status of the last
#              command to exit with a non-zero status, or zero if no command
#              exited with a non-zero status
set -euo pipefail

# Command-line argument parsing is done here:

# default args are '-a', '-b ARG'
ARGS="ab:"

# set the default argument values here
ARG_A=false
ARG_B="defaults for -b"

# set
while getopts "${ARGS}" opts; do
    case "${opts}" in
        a)
            ARG_A=true
            ;;
        b)
            ARG_B=${OPTARG}
            ;;
        ?)
            exit 1
    esac
done

echo $ARG_A
echo $ARG_B
