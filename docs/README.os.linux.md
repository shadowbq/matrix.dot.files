# Linux

## Build toolchain

build essentials is often packaged to include `gcc`, `make`, etc. 

### Ubuntu

You might select a default set of sane build tools and libraries like this:

`.matrix/os/Linux/Debian/bin/apt-bootstrap-build-utils`

## Ubuntu Setups

### Update Alternatives

`sudo update-alternatives --config editor`

## Modify SUDOERS

Set `wheel` users to not need to password to sudo

```shell
%wheel ALL=(ALL) NOPASSWD: ALL
```

## Mouse in boot terminal

`sudo apt install gpm`
