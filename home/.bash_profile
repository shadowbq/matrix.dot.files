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
# Get the base aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

###########################
# OS specific aliases and functions

bash_os="`uname -s`"

if [ -f "~/.matrix/${bash_os}/.bash_extension" ]; then
  . "~/.matrix/${bash_os}/.bash_extension"
else 
  echo -e "${RED} .bash_extension not found for ${bash_os}.${NORMAL}"
fi

###########################
# User configurable location to include addition configs to be loaded
if [ -f ~/.bash_matrix ]; then
   . ~/.bash_matrix
fi

###########################
# use .bash_local for settings specific to one system
if [ -f ~/.bash_local ]; then
  . ~/.bash_local
fi

###########################
# Last User specific environment and startup programs

PATH=$PATH:$HOME/bin
export PATH
