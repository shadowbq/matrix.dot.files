# Go-lang

Very simple extension for Go Lang

## What does it do?

It exports your gopath, and adds standard home go to your path.

```shell
export GOPATH=$HOME/.gopath
export PATH=$GOPATH:$GOPATH/bin:$PATH
```

## Is there a go virtual manager linked?

NO, but you can setup up `gvm` into matrix.dot.files

* https://github.com/moovweb/gvm

Install

```shell
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
gvm install go1.4
gvm use go1.4 --default
```

You would need to add to `.bash_local`:

`[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"`
