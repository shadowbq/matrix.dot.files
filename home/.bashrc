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

PATH="$HOME/.cargo/bin:$PATH"
PATH=$PATH:"/usr/local/sbin"
PATH=$PATH:"$HOME"/bin
export PATH

if command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
  # ARM macOS homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif command -v /usr/local/bin/brew >/dev/null 2>&1; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  echo "No homebrew detected"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -s "/home/shadowbq/.gvm/scripts/gvm" ]] && source "/home/shadowbq/.gvm/scripts/gvm"
