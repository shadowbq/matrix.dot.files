# OSX / macOS 

God help us with Catalina. 

It breaks.. so much.. local compilation, and the security restrictions are all over userspace.

Reference: https://stackoverflow.com/questions/58278260/cant-compile-a-c-program-on-a-mac-after-upgrading-to-catalina-10-15/58278392#58278392

## Installation help

### ffmpeg (circa 2019)

https://github.com/homebrew-ffmpeg/homebrew-ffmpeg

Install ffmpeg on OSX in 2019 with sane options

```shell
brew tap homebrew-ffmpeg/ffmpeg
brew install homebrew-ffmpeg/ffmpeg/ffmpeg
```


## Hacks

`/.matrix/Darwin/bin/osx_tweak`


## Disabling Dashboards 

With just a couple of simple terminal commands you can be rid of the Dashboard forever. To get started fire up the Terminal app and type the following into the console.

    defaults write com.apple.dashboard mcx-disabled -boolean YES
    killall Dock


And this is it! Your Dashboard will be gone forever, even when you restart your mac. However if you think you have made a big mistake then you can always undo this by entering the following command at the Terminal and restarting your computer.

    defaults write com.apple.dashboard mcx-disabled -boolean NO

