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

Dont confuse `pipx` with `npx` as they are not similar.

### Don't get confused on with your PATH

With a setup like lessc on Global @version 4.1.1

```
$ ls -la /Users/me/.nvm/versions/node/v15.0.1/bin/lessc
lrwxr-xr-x  1 me  staff  34 Feb 15 10:54 /Users/me/.nvm/versions/node/v15.0.1/bin/lessc -> ../lib/node_modules/less/bin/lessc
```

And $PROJECT with lessc @version 2.7.1 

```
$ ls -la ./node_modules/less/bin/lessc
-rwxr-xr-x  1 smacgregor  staff  16275 Apr 22  2016 node_modules/less/bin/lessc
```

You can see how this works.

```bash
# Defaults to Global NPM/NVM scope.
$ lessc -v
lessc 4.1.1 (Less Compiler) [JavaScript]
## Works to load in $PROJECT lessc even without quotes, but fails outside of project
$ npx lessc -v
lessc 2.7.1 (Less Compiler) [JavaScript]
## Work to load in $PROJECT lessc and needs quotes, then looks at nvm/npm versioned global scope!
$ npm exec -c 'lessc -v'
lessc 2.7.1 (Less Compiler) [JavaScript]
## Work to load in $PROJECT lessc and needs quotes, then looks at true global scope!
$ npx -c 'lessc -v'
lessc 4.1.1 (Less Compiler) [JavaScript]
```

### Note: (common syntax problems)

If you see version outputs like `7.0.1` or something not looking like `lessc x.x.x (Less Compiler) ..` thats *NOT* lessc, thats `node` reporting it's version. 

```
--ALERT-- npm exec lessc -v
--ALERT-- 7.0.3
```
