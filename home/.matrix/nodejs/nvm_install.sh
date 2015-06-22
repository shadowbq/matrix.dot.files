#!/usr/bin/env bash

# Single User Install into ~/.nvm
# Git clone the NVM env
git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`

# .matrix sources the nvm.sh file but during install the script needs it the first time.
# https://github.com/creationix/nvm
. ~/.nvm/nvm.sh

# Install a 0.10.x Version of NodeJS
nvm install 0.10

# Use a Node version
nvm use 0.10

# NVM Defaults (this is also sources on every shell launch)
nvm alias default 0.10
