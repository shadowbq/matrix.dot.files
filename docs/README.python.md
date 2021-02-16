# Python

Python can be a complete mess. Overtime py 2.7 to py 3.x has seen many tool turnovers so here are my opinions:

* I believe in using the os-distro system python as little as possible.
* I believe in using a method for python similar but not identical for ruby and node.
* In 2020, I assume a py 3.x os-distro system python for preparing overlays exist. 
* I use `pyenv` to shim in py 3.8.x as global
* I use `pipx` to install matrix.dot.file bins and inject libs that are python based like `powerline-status` into a `venv`.
* I use `pip` to install global libraries that aren't bin based.
* I use `poetry` to manage sandbox projects.
* I NO longer use py 2.x as the assumed os-distro therefor - `virtualenvwrapper` & `virtualenv` are gone.
* I NO longer use `virtualenv-burrito` as `virtualenvwrapper` is no longer used. (it served py 2.x very well, farewell)

## Import note on Homebrew

Homebrew will jerk around your python and completely destroy your pips and libs associated during a 3.X->3.X+1 transition. Be aware!

## PreRequisites

### Ubuntu Server

```
sudo apt install build-essential checkinstall
sudo apt install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev zlibb1g-dev
sudo apt install libffi-dev 
```

## Install pyenv to manage Python Versions

```
# Install PREREQs first
curl https://pyenv.run | bash
```

***Don't use system natives like brew or apt***

## Observe installed versions

```shell
pyenv versions
* system (set by /Users/smacgregor/.pyenv/version)
```

## Install a Sane Python 

```shell
pyenv install 3.8.4
pyenv global 3.8.4
```

## Install pipx to work with you

```
python -m pip install pipx
```

## Enable Pyenv-doctor

Note: `pyenv-doctor` may not be available as `pipx/pip`

```shell
git clone git://github.com/pyenv/pyenv-doctor.git $(pyenv root)/plugins/pyenv-doctor
```

## Enable Poetry

`poetry` is a tool to handle dependency installation as well as building and packaging of Python packages. It only needs one file to do all of that: the new, standardized `pyproject.toml`. It can export `requirements.txt` for legacy usage.

`poetry` will also detect if you are inside a `virtualenv` and install the packages accordingly. So, poetry can be installed globally and used everywhere.

```shell
pipx install poetry
```

## Building Python Packages for publication

You might want to build and publish to pypi. 

```shell
pip install setupext-janitor
pip install wheel
pipx install twine
```

View Implementation Examples:

* https://raw.githubusercontent.com/d2iq-shadowbq/powerkube-fork/v0.2.1/setup.py
* https://raw.githubusercontent.com/d2iq-shadowbq/powerkube-fork/v0.2.1/Makefile

Publish using twine via makefile:

```shell
make clean
make upload
```

## Build Python Packages with Poetry

```shell
poetry init # creating your pyproject.toml config
poetry build
poetry publish
```

## Reference

* https://realpython.com/intro-to-pyenv/
* https://realpython.com/pypi-publish-python-package/#poetry
* https://python-poetry.org/
* https://python-poetry.org/docs/cli/
