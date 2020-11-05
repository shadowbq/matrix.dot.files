# Secrets

We should never store unecrypted secrets on our machines. 

**Storing unencrypted Secret ENVs in a file is bad idea®.**

## The Good IDEA

Store secrets as ENVs on a file (`.bash_secrets`) that can be sourced from Bash, but don't write the file to the harddrive. Instead write it RSA 2048 encrypted then Base64 as (` ~/.bash_encrypted`) and decrypt in memory and source it as needed.

It is implemented as an alias `secrets_load` which evals bash function `_secrets_decrypt` on the `~/.bash_encrypted` file using gpg keys that are pin secured.

Source: `.matrix/functions/security_functions`

## Usage

```
$> env |grep -i SECRET_TOKEN
$> secrets_load
Please enter the passphrase to unlock the OpenPGP secret key:
"scott macgregor <shadowbq@gmail.com>"
2048-bit RSA key, ID 0123456789ABCDEF,
created 2019-12-28 (main key ID 0123456789ABCDEF).

Passphrase:
$> env |grep -i SECRET_TOKEN
SECRET_TOKEN=abcdefg12345678ZYXWV
```

## Setup

### Install GPG and Init

Install the GPG client

```
# (macosx) brew install gpg
# (linux) apt/yum install gpg
# (bsd) ... gpg
```

Init GPG

```
gpg --list-keys
gpg: directory '/Users/smacgregor/.gnupg' created
gpg: keybox '/Users/smacgregor/.gnupg/pubring.kbx' created
gpg: /Users/smacgregor/.gnupg/trustdb.gpg: trustdb created
```


### Set your pin entry method (required):

You will need a pin entry application *that works(looking at you mac)*

* `brew install pinentry-mac` 
* `apt install pinentry-tty`
* `yum install pinentry-tty`

* [Install Help](https://superuser.com/questions/520980/how-to-force-gpg-to-use-console-mode-pinentry-to-prompt-for-passwords)

```shell
ls -la /usr/*/bin/pinentry*
lrwxr-xr-x  1 smacgregor  admin  39 Nov  5 09:15 /usr/local/bin/pinentry -> ../Cellar/pinentry/1.1.0_1/bin/pinentry
lrwxr-xr-x  1 smacgregor  admin  46 Nov  5 09:15 /usr/local/bin/pinentry-curses -> ../Cellar/pinentry/1.1.0_1/bin/pinentry-curses
lrwxr-xr-x  1 smacgregor  admin  45 Nov  5 09:31 /usr/local/bin/pinentry-mac -> ../Cellar/pinentry-mac/0.9.4/bin/pinentry-mac
lrwxr-xr-x  1 smacgregor  admin  43 Nov  5 09:15 /usr/local/bin/pinentry-tty -> ../Cellar/pinentry/1.1.0_1/bin/pinentry-tty
```

A pure cli experience on servers or terminal

```
echo "pinentry-program /usr/bin/pinentry-tty" >> ~/.gnupg/gpg-agent.conf
```

For *debian/ubuntu* you *MUST* update the alternatives

```
sudo update-alternatives --config pinentry
```

For *macos/OSX* you can *ALTERNATIVELY* use a GUI/popup which also works with `keychain`

```
brew install pinentry-mac
echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
```

Reload the GPG Agent (or killit to force a restart)
```
gpg-connect-agent reloadagent /bye
# `killall gpg-agent` if that not working correctly
```

Note (This was seen as require at least on **macos**): 

`dot.matrix` should have solved the GPG_TTY issue, but if need it add it manually

```
env |grep GPG
GPG_TTY=/dev/ttys001
```

else 

`export GPG_TTY=$(tty)` to my `~/.bash_local`


### Make New Secrets Securely using RAMDisks

Given that you have a GPG KEY `0123456789ABCDEF0123456789ABCDEF`:

```
$> gpg --list-keys
/Users/scottmacgregor/.gnupg/pubring.kbx
----------------------------------------
pub   rsa2048 2019-12-28 [SC] [expires: 2021-12-27]
      0123456789ABCDEF0123456789ABCDEF
uid           [ultimate] scott macgregor <shadowbq@gmail.com>
sub   rsa2048 2019-12-28 [E] [expires: 2021-12-27]
```

Encrypt a bash script with contents: `export SECRET_TOKEN=abcdefg12345678ZYXWV` securely into `.bash_encrypted`

```
# Make your Linux secrets securely 
mkdir -p $HOME/tmpfs
mount -t tmpfs -o size=512m ramfs $HOME/tmpfs
# Make your MacOS secrets securely (macos_ramdisk is in .matrix/Darwin/bin)
macos_ramdisk mount
```

```
vi $HOME/tmpfs/.bash_secrets
[..Write.Secrets.here..]
cat $HOME/tmpfs/.bash_secrets | gpg --encrypt -r 0123456789ABCDEF0123456789ABCDEF --armor |base64 > ~/.bash_encrypted
```

```
# Wipe secrets ( Nuke: https://unix.stackexchange.com/a/271870/104660)
umount $HOME/tmpfs
macos_ramdisk umount $HOME/tmpfs
```

### Manual Loading of Secrets

As an alternative to `secrets_load`,  you can manually decrypt and load into current `tty` ENV.

``` 
$> eval $(cat ~/.bash_encrypted |base64 -d |gpg --decrypt 2> /dev/null)
```

### Working with your GPG Keys in more than one location.

GPG: Extract private key and import on different machine
Identify your private key by running `gpg --list-secret-keys`. 
You need the ID of your private key (second column)


Run this command to export your key: `gpg --export-secret-keys $ID > ~/.ssh/my-gpg-private-key.asc`.
Copy the key to the other machine ( scp is your friend)

`scp ~/.ssh/my-gpg-private-key.asc target:~/.ssh/.`

### Register an Existing Key

To import the key on the *target-server*, run `gpg --import ~/.ssh/my-gpg-private-key.asc`.

#### Trust the newly Imported key

Ensure the keys are correct by observing the ID with LONG format:

`gpg --keyid-format 0xLONG -k`

Everything showed up as normal **except** for the uid which now reads `[unknown]`:

```
uid [ unknown ] User < user@useremail.com >
```

Bump that trust, because its yours!

```
$> gpg --edit-key user@useremail.com
gpg> trust

Please decide how far you trust this user to correctly verify other users' keys
(by looking at passports, checking fingerprints from different sources, etc.)

  1 = I don't know or won't say
  2 = I do NOT trust
  3 = I trust marginally
  4 = I trust fully
  5 = I trust ultimately
  m = back to the main menu

Your decision? 5
Do you really want to set this key to ultimate trust? (y/N) y
gpg> save
```

Validate it is now `ultimate` trust.

`gpg --keyid-format 0xLONG -k`

```
uid [ ultimate ] User < user@useremail.com >
```

## Alternatives

### Using ENV from OSX-KEYCHAIN / Linux D-Bus Services

Sorah/ENVchain allows you to secure credential environment variables to your secure vault, and set to environment variables only when you called explicitly.

sorah/envchain - https://github.com/sorah/envchain

envchain - supports macOS keychain or D-Bus secret service (gnome-keyring) 

### Bad: LUKS / Container

Mount it and unmount it into a FS. 

### Worst Option: Unsecure File Fault 

Source it from `.bash_local`, and in linux give it SELINUX labels.
(http://blog.siphos.be/2015/07/restricting-even-root-access-to-a-folder/)

```
$> ls -lZ .bash_local
-rw-------. 1 scottmacgregor  root system_u:object_r:secrets_log_t 60 Dec 27 14:53 .bash_local
```

### Not an Option

Do something really stupid!
