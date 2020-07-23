# Python 

Python can be a complete mess as overtime 2.7 to 3.x has seen many tool turnovers:

* I believe in using the system python as little as possible.
* I believe in using a method for python similar but to identical for ruby and node.
* In 2020 I assume a 3.x system python for prep exists. 
* I use pyenv to shim in python 3.8.x as global
* I use pipx to install matrix.dot.file bins and inject libs that are python based like powerline-status into a venv.
* I use pip to install global libraries that aren't bin based.
* I use poetry to manage sandbox projects.
* I NO longer use python2.x as assumed base therefor - virtualenvwrapper & virtualenv are gone.
* I NO longer use virtualenv-burrito as virtualenvwrapper is no longer used. (served py2.x well farewell)

## Import note on Homebrew

Homebrew will jerk around your python and completely destroy your pips and libs associated during a 3.7->3.8 transition. Be aware.

## Install pyenv 

***Don't use system natives like brew or apt***

`$ curl https://pyenv.run | bash`

## Observe installed versions

```
pyenv versions
* system (set by /Users/smacgregor/.pyenv/version)
```

## Install a Sane Python 

```
pyenv install 3.8.4
pyenv global 3.8.4
```

## Install pipx to work with you

```
python -m pip install pipx
```

## Enable Pyenv-doctor

```
pipx install pyenv-doctor
```

## Enable Poetry

`poetry` is a tool to handle dependency installation as well as building and packaging of Python packages. It only needs one file to do all of that: the new, standardized `pyproject.toml`. It can export `requirements.txt` for legacy usage.

`poetry` will also detect if you are inside a `virtualenv` and install the packages accordingly. So, poetry can be installed globally and used everywhere.

* https://python-poetry.org/docs/cli/

```
pipx install poetry
```

## Reference:

* https://realpython.com/intro-to-pyenv/