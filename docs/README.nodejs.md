# Node-js

## How to install,update Node with NPM via NVM

The `profile` setting disables NVM from modifying the .bashrc

For the latest installer version (https://github.com/nvm-sh/nvm/releases)

```shell
PROFILE='/dev/null'
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
```

or 

```shell
(
  cd "$NVM_DIR"
  git fetch --tags origin
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"
```

Exit and Restart your shell.

Now list the latests versions of node, install the latest version of node, and ensure you use it.

```shell
nvm ls-remote
nvm install node
nvm use node
```

Confirm that you shell is now using the latest (in this case v22.3.0)

```shell
nvm ls
       v16.13.2
->      v22.3.0
default -> node (-> v22.3.0)
iojs -> N/A (default)
unstable -> N/A (default)
node -> stable (-> v22.3.0) (default)
stable -> 22.3 (-> v22.3.0) (default)
lts/* -> lts/iron (-> N/A)
...
node --version
v22.3.0
```

## Is there a NPM virtual manager?

Yes, and its preferred setup is `NVM` already enabled in the nodejs extension.

```shell
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
```

It also attempts to load bash_completions and print the current NVM version when present.

## How do I run local bins in the path?

* `NPM` is used for installing packages within the scope of a single project, while NPM global is used for installing packages system-wide, allowing you to access them from any project.
  * `NPM Global` When you install a package globally with npm (using `npm install -g <package_name>`), it adds the package to your system's global directory, which is typically located at `/usr/local` or where Node.js is installed on your system. This allows you to use that package in any project on your computer without needing to re-install it locally.
  * `Under NVM Context` When you install a package globally with NPM in an NVM environment, that package is installed into the global node_modules directory of that specific NVM environment. The global node_modules directory is determined by the path specified when you create or switch to a particular NVM environment.
* `NPX` allows running commands directly from an npm package without having to install it first, providing a convenient way to use CLI tools and executables without cluttering your local or global installation.
  
Note: Dont confuse `pipx` with `npx` as they are not similar. Additionally, `npx-alias` still only provides current context executions unlike `pipx` which holds its own context.

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
