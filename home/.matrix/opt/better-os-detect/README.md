# Better OS Detection

There are a number of ways to identify OS, and distributions but they vary on need and readability.

## .dot.matrix historically used `uname -s`

Note: Capital letters are often used with -s. Hence the need for capital letter directories in dot.matrix. 
TODO: downcase the directories in the repo and output 

```shell
$> uname -s
Darwin
```

## This opt provides some alternatives 

``` shell
 $> ./distro.guess 
Darwin 19.2.0
 $> ./config.guess 
x86_64-apple-darwin19.2.0
```

## There is an ultra high resolution here called: `config.guess`

```shell
wget -O config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD'
# autoconfig #=> wget -O config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'
```

## EXISTING ENV

`OSTYPE` Automatically set to a string that describes the operating system on 
which bash is executing. The default is system- dependent.

```shell
if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # ...
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
else
        # Unknown.
fi
```

## WSL

Windows 10 WSL/WSL2 has a non-straight-forward identification

```shell
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    echo "Windows 10 Bash"
else
    echo "Anything else"
fi
```
