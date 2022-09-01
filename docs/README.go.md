# Go-lang

Very simple extension for Go Lang

## GoLang

golang is a fast moving language that release an update every six months on average. Using `gvm` to manage your golang versions is preferred.

You need to bootstrap golang 1.4 with a binary or c++ developer tool set as all other golangs require golang to compile golang.

## What does it do?

It exports your gopath, and adds standard home go to your path.

```shell
export GOPATH=$HOME/.gopath
export PATH=$GOPATH:$GOPATH/bin:$PATH
```

## What other tools are needed generally

The system needs these tools to compile GCC on systems 

* gcc
* make
* bison

Ask an example in debian/ubuntu: `sudo apt install gcc make bison`

## Is there a go virtual manager linked?

Yes, but you need setup up `gvm` into matrix.dot.files

* https://github.com/moovweb/gvm

Install Golang Bootstrap 1.4 then build 1.15 and set it default.

Latest GOLANG: https://golang.org/doc/devel/release.html

```shell
GVM_NO_UPDATE_PROFILE=true
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source $HOME/.gvm/scripts/gvm
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.19
gvm use go1.19 --default
```
