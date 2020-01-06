# .bash_profile

###########################
# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

###########################
# Source global system definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

###########################
# Source user config override definitions specific to one system
# 
# NOTE: Configure your .matrix in the .matrix_config file. **
#
#- ! Changes to this file are NOT sent upstream.!
if [ -f "$HOME"/.matrix_config ]; then
        . "$HOME"/.matrix_config
fi

###########################
# Get the bash colors and aliases and functions
if [ -f "$HOME"/.bash_colors ]; then
        . "$HOME"/.bash_colors
fi

###########################
# Get the base aliases and functions
if [ -f "$HOME"/.bashrc ]; then
        . "$HOME"/.bashrc
fi

###########################
# Functions
source "$HOME"/.matrix/functions/.bash_extension

###########################
# OS specific aliases and functions

bash_os="`uname -s`"

if [ -f "$HOME"/.matrix/os/${bash_os}/.bash_extension ]; then
  . "$HOME"/.matrix/os/${bash_os}/.bash_extension
else
  echo_err "matrix .bash_extension not found for ${bash_os}."
fi

if [ -f "$HOME"/.matrix/os/${bash_os}/.bash_aliases ]; then
  . "$HOME"/.matrix/os/${bash_os}/.bash_aliases
fi

if [ -d "$HOME"/.matrix/os/${bash_os}/bin ]; then
  PATH=$PATH:"$HOME"/.matrix/os/${bash_os}/bin
  export PATH
fi

###########################
# Matrix Global Path bin
PATH=$PATH:"$HOME"/.matrix/bin

###########################
# .matrix Extentions to be loaded, with running checks
if [ -f "$HOME"/.bash_matrix ]; then
   . "$HOME"/.bash_matrix
fi

###########################
# use .bash_local for settings specific to one system
if [ -f "$HOME"/.bash_local ]; then
  . "$HOME"/.bash_local
fi

###########################
# use .bash_aliases for alias settings specific to one system
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

###########################
# Last User specific environment and startup programs


PATH=$PATH:"$HOME"/bin
export PATH


export PATH="$HOME/.cargo/bin:$PATH"
