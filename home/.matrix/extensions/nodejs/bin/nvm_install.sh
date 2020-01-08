#!/usr/bin/env bash

# Single User Install into ~/.nvm
# Git clone the NVM env
# git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`

# .matrix sources the nvm.sh file but during install the script needs it the first time.
# https://github.com/creationix/nvm
#. ~/.nvm/nvm.sh

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash

# Node.js 0.10.x is stable (ECMA 5.x)
# Node.js 0.12.x is current but dated ECMA 5.x (3.28.73 that ship with Node.js™ 0.12.x)
# IO.js is ECMA ES 6.x (V8 4.2.77.20, which includes ES6)
# Node.js will merge IO.js and IO.js will take over
# https://github.com/nodejs/dev-policy/blob/master/convergence.md

# Install a 0.10.x Version of NodeJS
# nvm install 0.10

# Install io.js Version of NodeJS
# https://github.com/nodejs/io.js
# nvm install iojs
nvm install node

# Use a Node version
# nvm use 0.10
# nvm use iojs
nvm use node

# NVM Defaults (this is also sources on every shell launch)
# nvm alias default 0.10
# nvm alias default iojs
nvm alias default node
