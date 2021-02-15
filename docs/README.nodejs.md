# Node-js

## How to install Node with NPM via NVM

The `profile` setting disables NVM from modifying the .bashrc

For the latest installer version (https://github.com/nvm-sh/nvm/releases)

```shell
PROFILE='/dev/null'
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
```

Restart your shell.

```shell
nvm install node
nvm ls-remote
nvm use node
```

## Is there a NPM virtual manager?

Yes, and its preferred setup is `NVM` already enabled in the nodejs extension.

```shell
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
```

It also attempts to load bash_completions and print the current NVM version when present.

## How do I run local bins in the path?

For global use, you should be using `NPX` for global bins. 

For project bins only load this in the current directory and you will be able to map node_module bins into your path.

`function npm-do { (PATH=$(npm bin):$PATH; eval $@;) }`

### Don't get confused on with your PATH

```bash
$ lessc -v
lessc 4.1.1 (Less Compiler) [JavaScript]
$ npx lessc -v
lessc 2.7.1 (Less Compiler) [JavaScript]
$ npm bin lessc -v
7.0.3
```
