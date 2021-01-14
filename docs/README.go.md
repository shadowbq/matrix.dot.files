# Go-lang

Very simple extension for Go Lang

## What does it do?

It exports your gopath, and adds standard home go to your path.

```shell
export GOPATH=$HOME/.gopath
export PATH=$GOPATH:$GOPATH/bin:$PATH
```

## Is there a go virtual manager linked?

Yes, but you need setup up `gvm` into matrix.dot.files

* https://github.com/moovweb/gvm

Install Golang Bootstrap 1.4 then build 1.15 and set it default.

```shell
GVM_NO_UPDATE_PROFILE=true
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.15
gvm use go1.15 --default
```

