# .bash_profile
# shellcheck disable=SC1091,SC1090
###########################
# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]]; then
  # Shell is non-interactive.  Be done now!
  return
fi

###########################
# Source global system definitions
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

###########################
# Source user config override definitions specific to one system
#
# NOTE: Configure your .matrix in the .matrix_config file. **
#
#- ! Changes to this file are NOT sent upstream.!
if [ -f "$HOME"/.matrix_config ]; then
  source "$HOME"/.matrix_config
fi

###########################
# Get the bash colors and aliases and functions
if [ -f "$HOME"/.bash_colors ]; then
  source "$HOME"/.bash_colors
fi

###########################
# Get the base aliases and functions
if [ -f "$HOME"/.bashrc ]; then
  source "$HOME"/.bashrc
fi

###########################
# Functions
source "$HOME"/.matrix/functions/.bash_extension

###########################
# OS specific aliases and functions

bash_os="$(uname -s)"

matrix_loader "os/${bash_os}"

###########################
# Matrix Global Path bin
PATH=$PATH:"$HOME"/.matrix/bin

###########################
# .matrix Extensions to be loaded, with running checks
if [ -f "$HOME"/.bash_matrix ]; then
  source "$HOME"/.bash_matrix
fi

###########################
# use .bash_local for settings specific to one system
if [ -f "$HOME"/.bash_local ]; then
  source "$HOME"/.bash_local
fi

###########################
# use .bash_aliases for alias settings specific to one system
if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

###########################
# Last User specific environment and startup programs
if [[ $TERM_PROGRAM != "vscode" ]]; then
  ~/.matrix/bin/neofetch
fi

[[ -s "/Users/smacgregor/.gvm/scripts/gvm" ]] && source "/Users/smacgregor/.gvm/scripts/gvm"
