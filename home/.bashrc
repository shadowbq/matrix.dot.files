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
# Color Definitions
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
# Load SSH KEYS

if [ "`type -t go_strict_ssh`" == "function" ]; then
  go_strict_ssh
fi

ssh-add -l >/dev/null 2>&1

if [ $? -eq 0 ]; then
 echo -ne "${GREEN}Keys successfully imported.${NORMAL}\n"
else
 echo -ne "${RED}No Keys Imported.${NORMAL}\n"
fi

#############################
# Tab completion for ssh hosts

SSH_COMPLETE=( $(cat ~/.ssh/known_hosts | \
cut -f 1 -d ' ' | \
sed -e s/,.*//g | \
uniq | sort ) )
complete -o default -W "${SSH_COMPLETE[*]}" ssh
export SSH_COMPLETE

#############################
# User specific aliases and functions
export EDITOR="vi"
export PAGER=less

# which vim &>/dev/null && editor="$(which vim)"
# export EDITOR="$editor -f"

export VISUAL="$editor"

export TERM=xterm-256color
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export CLICOLOR=1

export HISTSIZE=1000000
export HISTIGNORE="clear:bg:fg:cd:cd -:exit:date:w:* --help"
