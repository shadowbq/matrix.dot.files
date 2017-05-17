# ~/.bash_logout

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    if [ -x /usr/bin/clear_console ]; then 
      /usr/bin/clear_console -q
    else
      /usr/bin/clear
      tput reset
    fi  
fi
