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
if [ -f "$HOME"/.bashrc ]; then
        . "$HOME"/.bashrc
fi

###########################
# OS specific aliases and functions

bash_os="`uname -s`"

if [ -f "$HOME"/.matrix/${bash_os}/.bash_extension ]; then
  . "$HOME"/.matrix/${bash_os}/.bash_extension
else
  echo -e "${RED}matrix/.bash_extension not found for ${bash_os}.${NORMAL}"
fi

if [ -d "$HOME"/.matrix/${bash_os}/bin ]; then
  PATH=$PATH:"$HOME"/.matrix/${bash_os}/bin
  export PATH
fi

###########################
# Matrix Global Path bin
PATH=$PATH:"$HOME"/.matrix/bin

###########################
# User configurable location to include addition configs to be loaded
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

