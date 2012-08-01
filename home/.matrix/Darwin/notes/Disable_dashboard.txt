With just a couple of simple terminal commands you can be rid of the Dashboard forever. To get started fire up the Terminal app and type the following into the console.

    defaults write com.apple.dashboard mcx-disabled -boolean YES
    killall Dock


And this is it! Your Dashboard will be gone forever, even when you restart your mac. However if you think you have made a big mistake then you can always undo this by entering the following command at the Terminal and restarting your computer.

    defaults write com.apple.dashboard mcx-disabled -boolean NO

