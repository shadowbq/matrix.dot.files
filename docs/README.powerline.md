# Powerline

Powerline is a great status-line plugin for the shell and used in matrix.dot.files.

![matrix-screenshot](meta/powerline-screenshot.png)

* Extensible and feature rich, written in Python. 
* It also supports prompts and statuslines in several Linux utilities and tools.
* It has configurations and decorator colors developed using JSON.
* Fast and lightweight, with daemon support, which provides even more better performance

Enabled by Default in .matrix: `home/.matrix/powerline/.bash_extension`
**`check_powerline` is called from the extension during shell initiation to also enable it**

## Install Powerline

By default you will find this error `[ERROR] Powerline is not found, but enabled.` until it is disabled or installed as below.

Run `check_powerline_requirements` to validate all the prerequisites tools required for powerline are installed and reachable from the shell.

Prerequisites

* Fonts with special characters
* `socat` installed
* `pip` | `pipx` installed with python 3.8 or 3.9.

Additional Support Functions:

* Matrix function: `check_pip_powerline`
* Matrix function: `check_pipx_powerline`

### Fonts

Powerline requires some special font symbols so we recommend using particular fonts in terminal configuration.

There are many patched fonts that can be used:  

* https://github.com/powerline/fonts
* https://github.com/abertsch/Menlo-for-Powerline

Remember: You need the powerline font on the client rendering, not the server.  
(Example: If you are using OSX to connect to a linux machine you need `menlo-powerline` in your `iterm2` config on the macos, not the linux machine.)
  
macOS:

Configure `iterm2` for macOS to use `menlo for powerline` or `monaco`.

![iterm](meta/iterm.png)

Debian / BSD:

Install `apt|yum|etc.. install fonts-powerline`

Automated Install:

```shell
git clone https://github.com/powerline/fonts.git --depth=1 && cd fonts && ./install.sh && cd .. && rm -rf fonts
```

IDE / VSCode Terminal:

Many IDEs may spawn your terminal and you may want to also edit the font here:

![vscode](meta/vscode-menlo.png)

### PIPX way: (Preferred 2020+)

If you want to install powerline via `pipx` here are the commands:

```shell
pipx install powerline-status
pipx inject powerline-status psutil
pipx inject powerline-status powerline-gitstatus
pipx inject powerline-status powerline-inject
# (optional kubectl tooltips) pip inject powerline-status powerkube-fork
```

### PIP way (Legacy method)

If you are installing directly onto your python env.

```shell
pip install powerline-status
pip install psutil
pip install powerline-gitstatus
pip install powerline-inject
# (optional kubectl tooltips) pip install powerkube-fork
```

## TMUX integration

`~/.tmux.conf` by .matrix needs to be edited to point at where powerline-status really is!

```shell
# Legacy Python 2.7 with powerline-status
# source "/usr/local/lib/python2.7/dist-packages/powerline/bindings/tmux/powerline.conf"
# System Python 3.8 with powerline-status
# source "/usr/local/lib/python3.8/site-packages/powerline/bindings/tmux/powerline.conf"
# Pyenv 3.8 with PIPX Install of powerline-status
source "~/.local/pipx/venvs/powerline-status/lib/python3.8/site-packages/powerline/bindings/tmux/powerline.conf"
```

## Theme & ColorScheme

numerous addons are enabled like `powerline git-status` in the theme dot.matrix so it works out of the box.

```shell
$HOME/.config/powerline/colorschemes/default.json
$HOME/.config/powerline/colorschemes/matrix.json
$HOME/.config/powerline/themes/shell/__main__.json
$HOME/.config/powerline/themes/shell/matrix.json 
```

## Is Powerline-status Daemon Running and Loaded?

Is powerline loaded in bash?

`LC_ALL=C type _powerline_return`

If it returns this .. its loaded.

```shell
_powerline_return is a function
_powerline_return ()
{
    return $1
}
```

If its not loaded ..

```shell
-bash: type: _powerline_return: not found
```

## Customizations beyond Matrix.dot.files

### Configuration

Powerline has a number of configurations: 

DOCS: https://powerline.readthedocs.io/en/master/configuration.html

#### VSCode Terminal

Powerline for the VSCODE Terminal

https://dev.to/mattstratton/making-powerline-work-in-visual-studio-code-terminal-1m7

### For Quick Customization

If you want to modify some file you can create `~/.config/powerline` directory and put modifications there: all configuration files are merged with each other.

The ***dot.matrix*** comes with `.config/powerline/config.json`

```json
{
  "ext": {
    "shell": {
       "theme": "matrix"
     }
  }
}
```

This overrides the default theme `/usr/local/lib/python3.7/site-packages/powerline/config_files/config.json`:

```json
{
    "ext": {
        "shell": {
            "colorscheme": "default",
            "theme": "default",
            "local_themes": {
                    "continuation": "continuation",
                    "select": "select"
            },
        },
    },
}
```

Reference: https://powerline.readthedocs.io/en/latest/configuration.html#quick-guide

### ColorScheme

 `solarized` is available in the `powerline-status` repo for `shell` if you want to enable it instead of `default`.

## Extensions

Each extension (vim, tmux, etc.) has its own theme, and they are located in `config directory/themes/extension/default.json.` 

### Bash

Path representative of pip installed through 3.7 non-system

`/usr/local/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh`

### TMUX

`/usr/local/lib/python3.7/site-packages/powerline/bindings/tmux/powerline.conf`


There are custom TMUX samples like this:

`https://github.com/sbernheim4/dotfiles/blob/master/.tmux.conf`  
`https://github.com/powerline/powerline/blob/43c1707206781859aee05090b6e32d6e54e73649/powerline/bindings/tmux/powerline-base.conf`  

## Locating Powerline

```shell
$> pip show powerline-status
Name: powerline-status
Version: 2.7
Summary: The ultimate statusline/prompt utility.
Home-page: https://github.com/powerline/powerline
Author: Kim Silkebaekken
Author-email: kim.silkebaekken+vim@gmail.com
License: MIT
Location: /usr/local/lib/python3.7/site-packages
Requires:
Required-by:
```

## Tutorials

Customizing Powerline with Weather Plugin:

https://stackoverflow.com/a/29874715/1569557

Full tutorial hacking into Powerline

https://computers.tutsplus.com/tutorials/getting-spiffy-with-powerline--cms-20740

## Powerline Segments

A common **segment/function** you might want to add to a `theme` is `env.environment`

```json
{
    "function": "powerline.segments.common.env.environment",
    "priority": 30
},
```

```json
			{
                "function": "powerline.segments.common.env.variable",
                "priority": 50,
                "before": "HH ",
                "args": {
                    "variable": "HOME"
                }
            },
```

```python
@requires_segment_info
def environment(pl, segment_info, variable=None):
	'''Return the value of any defined environment variable

	:param string variable:
		The environment variable to return if found
	'''
	return segment_info['environ'].get(variable, None)
```

Reference: https://powerline.readthedocs.io/en/master/configuration/segments/common.html#powerline.segments.common.env.environment

## Down the rabbit hole of TMUX customs

Its gotten more confusing on where to inject tmux interpolation into powerline configs

Also faced the similar issue (https://github.com/powerline/powerline/issues/1566). Not sure how but adding power-config command directly in `tmux.conf` worked for me.
`run-shell 'powerline-config tmux setup'`

These files are to be sourced by `powerline-config tmux setup` which is called by `powerline.conf`.

```shell
if-shell 'env "$POWERLINE_CONFIG_COMMAND" tmux setup' '' 'run-shell "powerline-config tmux setup"'
# vim: ft=tmux
```

```shell
$> powerline tmux right
#[fg=colour233,bg=default,nobold,noitalics,nounderscore] #[fg=colour247,bg=colour233,nobold,noitalics,nounderscore] ↑  21h 41m 42s#[fg=colour241,bg=colour233,nobold,noitalics,nounderscore] #[fg=colour2,bg=colour233,nobold,noitalics,nounderscore] 1.5 #[fg=colour2,bg=colour233,nobold,noitalics,nounderscore]1.7 #[fg=colour2,bg=colour233,nobold,noitalics,nounderscore]1.6#[fg=colour236,bg=colour233,nobold,noitalics,nounderscore] #[fg=colour247,bg=colour236,nobold,noitalics,nounderscore] 2019-11-07#[fg=colour241,bg=colour236,nobold,noitalics,nounderscore] #[fg=colour252,bg=colour236,bold,noitalics,nounderscore] 08:13#[fg=colour252,bg=colour236,nobold,noitalics,nounderscore] #[fg=colour16,bg=colour252,bold,noitalics,nounderscore]  percentage.lan  scottmacgregor  ~  
```

```shell
$> tmux show -g | grep status
@plugin "tmux-plugins/tmux-online-status"
status on
status-bg colour233
status-fg colour231
status-format[0] "#[align=left range=left #{status-left-style}]#{T;=/#{status-left-length}:status-left}#[norange default]#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}}, #{window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}}, #{window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{window-status-activity-style},default}}, #{window-status-activity-style},}}]#{T:window-status-format}#[norange default]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{window-status-current-style},defastatus-left-length 20
status-left-style default
status-position bottom
status-right "#(env \"$POWERLINE_COMMAND\" $POWERLINE_COMMAND_ARGS tmux right -R pane_id=\"`tmux display -p \"#\"\"D\"`\" --width=`tmux display -p \"#\"\"{client_width}\"` -R width_adjust=`tmux show-options -g status-left-length | cut -d\" \" -f 2`)"
status-right-length 150
status-right-style default
status-style fg=colour231,bg=colour233
```

## Clipboards and TMUX

```shell
$>  tmux show-options -g -s set-clipboard
set-clipboard external
```

## Reference

* https://powerline.readthedocs.io/en/latest/usage/shell-prompts.html#bash-prompt
* https://github.com/d2iq-shadowbq/powerline-inject
* https://github.com/jaspernbrouwer/powerline-gitstatus
