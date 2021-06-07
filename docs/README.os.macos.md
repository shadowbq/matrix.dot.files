# OSX / macOS

## Modern OSX

***God help us with Catalina / BigSur.***

* `ZSH` has become the default standard (BigSur 11.x).
* GNU-tools GNU2 still is base. (Users need to install coreutils)
* `GIT` is backed by *XCode* which has to get seperately updated.
* Security restrictions are all over user-space.
* `Ruby` is being removed from the BigSur in the future.
* `Python 2.x` is removed.

Reference: https://stackoverflow.com/questions/58278260/cant-compile-a-c-program-on-a-mac-after-upgrading-to-catalina-10-15/58278392#58278392

### ZSH Notes

Before you get into `matrix.dot.files` and back onto the normal bash terminal, ZSH history is *incomplete* by default. Note some PATHS and history listed here.

```shell
# ~/.zshrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Created by `pipx` on 2021-06-02 15:40:55
export PATH="$PATH:$HOME/.local/bin"

# Created by `pipx` on 2021-06-02 15:40:58
export PATH="$PATH:$HOME/Library/Python/3.9/bin"

alias history="history 1"
```

## Opt

### Sublime3 Keymaps

Settings and keymaps are stored within both packed and unpacked packages. Those can be overruled/extended by saving them to `$HOME/Library/Application Support/Sublime Text 3/Packages/User/.`

Install the home/end key fix for sublime

```shell
$> cp "$HOME/.matrix/os/Darwin/opt/Default (OSX).sublime-keymap" "$HOME/Library/Application Support/Sublime Text 3/Packages/User/."
```

## Installation help

### ffmpeg (circa 2019)

https://github.com/homebrew-ffmpeg/homebrew-ffmpeg

Install ffmpeg on OSX in 2019 with sane options

```shell
brew tap homebrew-ffmpeg/ffmpeg
brew install homebrew-ffmpeg/ffmpeg/ffmpeg
```

## Iterm2

There are a few iterm-color schemes. Make sure to also set your font to a powerline compliant one if you are using powerline.

`.matrix/os/Darwin/opt/*.itermcolors`

## Bins

There are a few bins like `java-switch` that are useful.

## OSX Tweaks

There are a number of different OSX tweaks `SYSTEM_*` that can be run like:

* show all files in OSX Finder
* don't write DSStores in shares
* etc

### Fixing `git` XCode Errors on Update

Running `git` after an update, even a minor one in Catalina or BigSur causes issues:

The `xcrun` error:

```shell
xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun
```

This can be solved often by:

`xcode-select --install`

If that doesn’t work, force it to reset. You’ll need `sudo` access for this one:

`sudo xcode-select --reset`

or by Login or sign up here:

https://developer.apple.com/download/more/

Look for: "Command Line Tools for Xcode 12.x" in the list of downloads Then click the dmg and download.

### Other useful tools

cli notification disabled  

https://github.com/sindresorhus/do-not-disturb-cli

### Disabling Dashboards

With just a couple of simple terminal commands you can be rid of the Dashboard forever. To get started fire up the Terminal app and type the following into the console.

```shell
    defaults write com.apple.dashboard mcx-disabled -boolean YES
    killall Dock
```

And this is it! Your Dashboard will be gone forever, even when you restart your mac. However if you think you have made a big mistake then you can always undo this by entering the following command at the Terminal and restarting your computer.

```shell
    defaults write com.apple.dashboard mcx-disabled -boolean NO
```


## Using Natifier to build OSX Apps

Install nativefier via npm.

`nativefier -i ~/Downloads/github-1.png --name "GitHub" --darwin-dark-mode-support --single-instance -f -m --internal-urls "(.*?)" "https://github.com"`
