# TMUX

Tmux is a great terminal emulator that can help you do numerous things

* Split Windows
* Detach and leave terminals open
* Attach PAIR Co-Worker to terminal
* start a build or compilation process
* start a forground service
* tail a log file or two 

## Dot Matrix Modifications

* `ctrl-space` is the Bindkey
* *TPM* - the tmux plugin manager is fully setup.
* `powerline` with enhanced outputs is fully integrated and ready to go.
* `bash` is the choice shell
* `.tmux.conf` and `.tmux.conf.d` are both used.

### Mappings

#### Windows (Tabs)

* Window Selection is `nN` mapped to `next,Previous`
* `c`  create window
* `w`  list windows
* `f`  find window
* `,`  name window
* `&`  kill window

#### Panes (Visual splits)

* Pane Selection is `hjkl` mapped to `Left, Up, Down, Right`
* Pane Resize is `HJKL` mapped to `+5` on `Left, Up, Down, Right`
* Spliting is `|-c=` mapped to `SplitH,SplitV,NewW,Sync`

## TPM Plugins

https://github.com/tmux-plugins/list

Installed are:

```shell
set -g @plugin 'tmux-plugins/tmux-battery'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-online-status'
```

## Powerline in TMUX

Note that you must source how powerline is actually installed in `.tmux.conf`. This may include changing the directive if you dont use PIPX. 

It is done already for you if you followed the basic install directions.

```shell
# Pyenv 3.8 with PIPX Install of powerline-status
source "~/.local/pipx/venvs/powerline-status/lib/python3.8/site-packages/powerline/bindings/tmux/powerline.conf"
```

## TMUX Shared Session

1. Alice and Bob ssh into the same server and belong to the same user group `users`.
1. Alice creates a new tmux sesssion: `tmux -S /var/shared.tmux`
1. Alice modify's file ownership binding: `chgrp users /var/shared.tmux`
1. Alice modify's file permission binding: `chmod g+rwx /var/shared.tmux`
1. Bob connects to that session: `tmux attach -t /var/shared.tmux`
1. `Profit $$$`

Note Alternative tmux wrapper: https://github.com/zolrath/wemux

## TMUX Detach and Attach

1. Start `tmux` in a shell
1. Do work..
1. Detach `ctrl-space d` during the session
1. From outside of tmux run `tmux ls` to show available sessions
   * Attach via `tmux a` to last session
   * Attach Named session `tmux a -t mysession`
1. Do work..
   * `exit` to close tmux session.
   * `tmux kill-session -t mysession` to kill specific session
   * `tmux kill-session -a` kill/delete all sessions but the current

## TMUX Cheat Sheet

`ctrl-space` + `?` is used to show the full list of keybindings

```text
C-Space C-o     Rotate through the panes                                                                                                                                                                             [13/13]
C-Space C-z     Suspend the current client
C-Space Space   Select next layout
C-Space !       Break pane to a new window
C-Space "       Split window vertically
C-Space #       List all paste buffers
C-Space $       Rename current session
C-Space %       Split window horizontally
C-Space &       Kill current window
C-Space '       Prompt for window index to select
C-Space (       Switch to previous client
C-Space )       Switch to next client
C-Space ,       Rename current window
C-Space .       Move the current window
C-Space /       Describe key binding
C-Space 0       Select window 0
C-Space 1       Select window 1
C-Space 2       Select window 2
C-Space 3       Select window 3
C-Space 4       Select window 4
C-Space 5       Select window 5
C-Space 6       Select window 6
C-Space 7       Select window 7
C-Space 8       Select window 8
C-Space 9       Select window 9
C-Space :       Prompt for a command
C-Space ;       Move to the previously active pane
C-Space ?       List key bindings
C-Space D       Choose a client from a list
C-Space E       Spread panes out evenly
C-Space M       Clear the marked pane
C-Space [       Enter copy mode
C-Space ]       Paste the most recent paste buffer
C-Space d       Detach the current client
C-Space f       Search for a pane
C-Space m       Toggle the marked pane
C-Space q       Display pane numbers
C-Space s       Choose a session from a list
C-Space t       Show a clock
C-Space w       Choose a window from a list
C-Space x       Kill the active pane
C-Space z       Zoom the active pane
...
```

## OSX - PASTE Buffer issues

There is line in the config to handle this

```shell
# ~/.tmux.conf
set-option -g default-command "reattach-to-user-namespace -l $SHELL"
```

You may also likely need to *Allow terminal application access to paste buffer* in iTERM2 profile.

Read more here: https://github.com/tmux-plugins/tmux-yank#requirements


