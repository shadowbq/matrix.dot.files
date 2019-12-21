# Powerline

Enable Powerline in bash:

* https://powerline.readthedocs.io/en/latest/usage/shell-prompts.html#bash-prompt

Enabled by Default in .matrix: `home/.matrix/powerline/.bash_extension`

**`check_powerline` is called which also enables it**

## Install extras

https://github.com/jaspernbrouwer/powerline-gitstatus

## Loaded?

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

## Configuration

Powerline has a number of configurations: 

DOCS: https://powerline.readthedocs.io/en/master/configuration.html

### For Quick Customization:

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

### Bash:

`/usr/local/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh`

### TMUX:

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
