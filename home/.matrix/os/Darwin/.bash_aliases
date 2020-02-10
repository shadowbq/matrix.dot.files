# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

alias ls='ls -G'
alias ldd='otool -L'
alias libtoolize='glibtoolize'
alias users-list="dscacheutil -q user | grep -A 3 -B 2 -e uid:\ 5'[0-9][0-9]'"
alias groups-list="dscl . list /Group | grep -v '^_'"
alias users-list-all="dscl . list /Users | grep -v '^_'"

alias code='open -a "Visual Studio Code.app"'
alias firefox='open -a Firefox.app'
alias chrome='open -a Chrome.app' 
alias finder='open -a Finder.app'
alias play='open -a VLC.app'
alias sublime='open -a "Sublime Text.app"'
alias seashore='open -a "Seashore.app"'
alias typora='open -a "Typora.app"'
alias play-cli='mpg123'
