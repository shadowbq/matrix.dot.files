# Node-js

## How to install Node and NVM

The `profile` setting disables NVM from modifying the .bashrc

```shell
PROFILE='/dev/null'
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
```

Restart your shell.

```shell
nvm install node
nvm ls-remote
nvm use node
```

## Is there a NVM virtual manager?

Yes, and its preferred setup is `NVM` already enabled in the nodejs extension.

```shell
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
```

It also attempts to load bash_completions and print the current NVM version when present.
