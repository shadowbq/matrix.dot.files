# Powerline

Powerline has a number of configurations: 

`/usr/local/lib/python3.7/site-packages/powerline/bindings/tmux/powerline.conf`

* https://powerline.readthedocs.io/en/master/configuration.html

There are samples like this

`https://github.com/sbernheim4/dotfiles/blob/master/.tmux.conf`

Its gotten more confusing on where to inject tmux interpolation into powerline configs

Also faced the similar issue (https://github.com/powerline/powerline/issues/1566). Not sure how but adding power-config command directly in `tmux.conf` worked for me.
`run-shell 'powerline-config tmux setup'`

These files are to be sourced by `powerline-config tmux setup` which is called by `powerline.conf`.

```
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
