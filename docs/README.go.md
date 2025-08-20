# Go-lang

Very simple extension for Go Lang

## GoLang

golang is a fast moving language that release an update every six months on average. Using `gvm` to manage your golang versions is preferred.

You need to bootstrap golang 1.4 with a binary or c++ developer tool set as all other golangs require golang to compile golang.

## GVM ERROR NOTE

gvm in 2025 has an error on overriding cd() with a function. 

`.gvm/scripts/env/cd` - The eval is parsing spaces correctly. The below is how you can patch it. 

```
 19 if __gvm_is_function cd; then
 20     # echo "CD is a function"
 21     eval "$(echo "__gvm_oldcd()"; declare -f cd | sed '1 s/{/\'$'\n''{/' | tail -n +2)"
 22 elif [[ "$(builtin type cd)" == "cd is a shell builtin" ]]; then
 23     # echo "CD is builtin"
 24     #eval "$(echo "__gvm_oldcd() { builtin cd \"\$@\"; return \$?; }")"
 25     eval "$(echo "__gvm_oldcd() { if [[ -z \"\$*\" ]]; then builtin cd; return \$?; else builtin cd \"\$*\"; return \$?; fi }"    )"
 26 fi
```

The PR in Github is here.. 
* https://github.com/moovweb/gvm/issues/457
* https://github.com/moovweb/gvm/pull/482

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

You might find this error if you are missing these:

```shell
$> source ~/.gvm/scripts/gvm
ERROR: Missing requirements.
```

## Is there a go virtual manager linked?

Yes, but you need setup up `gvm` into matrix.dot.files

* https://github.com/moovweb/gvm

Install Golang Bootstrap 1.4 then build 1.15 and set it default.
Note: building 1.21 or later requires 1.20 as a substep.

Latest GOLANG: https://golang.org/doc/devel/release.html

```shell
GVM_NO_UPDATE_PROFILE=true
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source $HOME/.gvm/scripts/gvm
```
Prior to go1.21

```
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.19
gvm use go1.19 --default
```

After go release 1.21

```shell
gvm install go1.20 -B
gvm use go1.20
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.23
gvm use go1.23 --default
```


## 2024 Problems (MacOS AMD64)

The binary switch was not working well on GVM for the AMD64 mac.

`go1.4 -B` wasn't pulling and I could not get around the `bash exit:9` error (codesigning binary problem)

### Work Around Using Brew

Install Go version 1.22 explictly

```shell
brew install gcc make bison go@1.22
```

Make Go mapping easier with a symlink

```shell
cd /usr/local/opt
ln -s go@1.22 go
```

Change the @ in the root 
Default `GOROOT='/usr/local/Cellar/go@1.22/1.22.6/libexec'`

Edit .profile_local

Update `$GOROOT` and `$PATH`

`export PATH="/usr/local/opt/go@1.22/bin:$PATH"' >> ~/.bash_profile`

```bash
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:$(brew --prefix golang)/bin"
```

Results in `GOROOT='/usr/local/opt/go/libexec'`

## Validate Go Installed Correctly

Start a new windows and use `go env`

```shell
$> go env
GO111MODULE=''
GOARCH='amd64'
GOBIN=''
GOCACHE='/Users/xxxx/Library/Caches/go-build'
GOENV='/Users/xxxx/Library/Application Support/go/env'
GOEXE=''
GOEXPERIMENT=''
GOFLAGS=''
GOHOSTARCH='amd64'
GOHOSTOS='darwin'
GOINSECURE=''
GOMODCACHE='/Users/xxxx/.gopath/pkg/mod'
GONOPROXY=''
GONOSUMDB=''
GOOS='darwin'
GOPATH='/Users/xxxx/.gopath'
GOPRIVATE=''
GOPROXY='https://proxy.golang.org,direct'
GOROOT='/usr/local/opt/go/libexec'
GOSUMDB='sum.golang.org'
GOTMPDIR=''
GOTOOLCHAIN='auto'
GOTOOLDIR='/usr/local/opt/go/libexec/pkg/tool/darwin_amd64'
GOVCS=''
GOVERSION='go1.22.6'
GCCGO='gccgo'
GOAMD64='v1'
AR='ar'
CC='cc'
CXX='c++'
CGO_ENABLED='1'
GOMOD='/dev/null'
GOWORK=''
CGO_CFLAGS='-O2 -g'
CGO_CPPFLAGS=''
CGO_CXXFLAGS='-O2 -g'
CGO_FFLAGS='-O2 -g'
CGO_LDFLAGS='-O2 -g'
PKG_CONFIG='pkg-config'
GOGCCFLAGS='-fPIC -arch x86_64 -m64 -pthread -fno-caret-diagnostics -Qunused-arguments -fmessage-length=0 -ffile-prefix-map=/var/folders/4r/55dztgbn7xj37z7p6fh78n3r0000gn/T/go-build2187524844=/tmp/go-build -gno-record-gcc-switches -fno-common'
```
