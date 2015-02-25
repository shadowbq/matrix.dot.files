
export WORKON_HOME="$HOME/.virtualenvs"
export PIP_VIRTUALENV_BASE="$WORKON_HOME"
export PIP_RESPECT_VIRTUALENV=true

venvb_py_path="$HOME/.venvburrito/lib/python2.7/site-packages"
if [ -z "$PYTHONPATH" ]; then
    export PYTHONPATH="$venvb_py_path"
elif ! echo $PYTHONPATH | grep -q "$venvb_py_path"; then
    export PYTHONPATH="$venvb_py_path:$PYTHONPATH"
fi

venvb_bin_path="$HOME/.venvburrito/bin"
if ! echo $PATH | grep -q "$venvb_bin_path"; then
    #export PATH="$venvb_bin_path:$PATH"
    export PATH="$PATH:$venvb_bin_path"
fi

. $HOME/.venvburrito/bin/virtualenvwrapper.sh
if ! [ -e $HOME/.venvburrito/.firstrun ]; then
    echo
    echo "To create a virtualenv, run:"
    echo "mkvirtualenv <cool-name>"
    touch $HOME/.venvburrito/.firstrun
fi
