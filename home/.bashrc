# .bashrc

# NOTE: Bashrc are loaded by .bash_profile!

#############################
# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.

if [[ $- != *i* ]]; then
  # Shell is non-interactive.  Be done now!
  return
fi

#############################
# User specific aliases and functions
# Setting up Defaults for .matrix prior to functions / OS calls
# (exist as .matrix extensions) GREP MATCHERS: nvm.sh rvm pythonenv

export GPG_TTY=$(tty)

export EDITOR="vi"
export PAGER=less
export VISUAL="$editor"


PATH=$PATH:"/usr/local/sbin"
PATH=$PATH:"$HOME"/bin
export PATH




