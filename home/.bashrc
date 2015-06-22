# .bashrc

# NOTE: Bashrc are loaded by .bash_profile!

#############################
# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.

if [[ $- != *i* ]] ; then
        # Shell is non-interactive.  Be done now!
        return
fi

#############################
# Color Definitions(non-exported) used for .matrix loader
BGREEN='\033[1;32m'
GREEN='\033[0;32m'
BRED='\033[1;31m'
RED='\033[0;31m'
BBLUE='\033[1;34m'
BLUE='\033[0;34m'
BYELLOW='\033[1;33m'
YELLOW='\033[0;33m'
NORMAL='\033[00m'

#############################
# User specific aliases and functions
# Setting up Defaults for .matrix prior to functions / OS calls
# (exist as .matrix extensions) GREP MATCHERS: nvm.sh rvm pythonenv

export EDITOR="vi"
export PAGER=less

export VISUAL="$editor"

export STRICT_SSH=false

export TERM=xterm-256color
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export CLICOLOR=1

export HISTSIZE=1000000
export HISTIGNORE="clear:bg:fg:cd:cd -:exit:date:w:* --help"
