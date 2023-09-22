# Python

Python can be a complete mess. Overtime py 2.7 to py 3.x has seen many tool turnovers so here are my opinions:

* I believe in extending the os-distro system python as *little as possible*.
* I believe in using a user-mode multi-version method for python similar but not identical for ruby and node.
* Since 2020, I assume a py 3.x os-distro system python for preparing overlays exist. (ugh.. macOS)
* I use `pyenv` to shim in py 3.x as global.
* I use `pipx` to install *matrix.dot.file* `bins` and inject libs for those bins that are python based like `powerline-status` into a `venv`.
* I use `pip` to install global libraries that aren't bin based.
* I use `poetry` to manage python developed sandbox projects.
* I *NO longer use* py 2.x as the assumed os-distro therefor - `virtualenvwrapper` & `virtualenv` are gone.
* I *NO longer use* `virtualenv-burrito` as `virtualenvwrapper` is no longer used. (it served py 2.x very well, farewell)

## Import note on Homebrew

Homebrew will jerk around your python isntallation and completely destroy your pips and libs associated during a 3.X->3.X+1 transition. Be aware!

## PreRequisites

### Ubuntu Server

```shell
sudo apt install -y build-essential checkinstall
sudo apt install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev zlib1g-dev
sudo apt install -y libffi-dev 
```

## Install pyenv to manage Python Versions

```shell
# Install PREREQs first
curl https://pyenv.run | bash
```

***Don't use system natives like brew or apt***

## Observe installed versions

```shell
pyenv versions
* system (set by /Users/smacgregor/.pyenv/version)
```

## Upgrade `Pyenv`

```shell
pyenv update
```

## Install a Sane Python 

```shell
pyenv install 3.8.4
pyenv global 3.8.4
```

## Restart your shell

Close and Restart the shell before continuing.

## Install pipx to work with you

```shell
python -m pip install pipx
```

## Optional: Install Pyenv-VirtualEnvs

***Watch this 2015 Depreciation (https://github.com/pyenv/pyenv-virtualenv/issues/135#issuecomment-466306558)***

`pyenv` is enabled to install *virtualenv* 

Create a new virtual env:

`pyenv virtualenv myworkspace`

List available virtual envs:

`pyenv virtualenvs`

## Optional: Enable Pyenv-doctor

Note: `pyenv-doctor` may not be available as `pipx/pip`

```shell
git clone git://github.com/pyenv/pyenv-doctor.git $(pyenv root)/plugins/pyenv-doctor
```

## Optional: Building Python Packages for publication

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
## PIPX 

PIPX can use multiple different versions of the python on your system!

### Need NEW Python Version but not ready to swap Global/Default to NEW 

```shell 
$> python --version
Python 3.9.0

$> pyenv versions
  system
* 3.9.0 (set by /Users/XXXX/.pyenv/version)
  3.9.0/envs/myworkspace
  myworkspace --> /Users/XXXX/.pyenv/versions/3.9.0/envs/myworkspace
$> pyenv install 3.11.5
$> pyenv shell 3.11.5
$> pyenv versions
  system
* 3.9.0 (set by /Users/smacgregor/.pyenv/version)
  3.9.0/envs/myworkspace
  3.11.5
  myworkspace --> /Users/XXXX/.pyenv/versions/3.9.0/envs/myworkspace
$> # Install pipx via pip3 without fear into each python version needed.
$> pip install pipx
$> pipx install abc-toolkit
$> pipx list
venvs are in /Users/XXXX/.local/pipx/venvs
apps are exposed on your $PATH at /Users/XXXX/.local/bin
   package abc-toolkit 3.3.1, Python 3.11.5
    - abc-tool
   package powerline-status 2.7, Python 3.9.0
    - powerline
    - powerline-config
    - powerline-daemon
    - powerline-lint
    - powerline-render
   package pygments 2.7.2, Python 3.9.0
    - pygmentize
$> pyenv shell --unset
$> python --version
Python 3.9.0
$> abc-tool
.... works!
```

## Optional: Enable Poetry

`poetry` is a tool to handle dependency installation as well as building and packaging of Python packages. It only needs one file to do all of that: the new, standardized `pyproject.toml`. It can export `requirements.txt` for legacy usage.

`poetry` will also detect if you are inside a `virtualenv` and install the packages accordingly. So, poetry can be installed globally and used everywhere.

```shell
pipx install poetry
```

## Example: Build Python Packages with Poetry

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
