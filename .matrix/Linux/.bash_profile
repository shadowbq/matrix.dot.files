# .bash_profile

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# Include all your proxy configs in this file
if [ -f ~/.bash_proxy ]; then
        . ~/.bash_proxy
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
