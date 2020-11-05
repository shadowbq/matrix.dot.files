# Secrets

We should never store unecrypted secrets on our machines. 

**This is bad®.**

## The IDEA

Store secrets as ENVs on a file (`.bash_secrets`) that can be sourced from Bash, but dont write the file to the harddrive. Instead write it encrypted as (` ~/.bash_encrypted`) and decrypt and source it as needed.

## Load Secrets from an Encrypted file
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

Decrypt and load into current `tty` ENV.

```
$> # alias secrets-load='eval $(cat ~/.bash_encrypted |base64 -d |gpg --decrypt 2> /dev/null)' 
$> eval $(cat ~/.bash_encrypted |base64 -d |gpg --decrypt 2> /dev/null)
```

### Set your pin entry method (required):

You will need a pin entry application

Example: `apt|brew|yum install pinentry-tty` *[Install Help](https://superuser.com/questions/520980/how-to-force-gpg-to-use-console-mode-pinentry-to-prompt-for-passwords)

```shell
ls -la /usr/bin/pinentry*
ls: /usr/bin/pinentry*: No such file or directory
macos$> ls -la /usr/local/bin/pinentry*
lrwxr-xr-x  1 scottmacgregor  admin  39 Oct 28 21:21 /usr/local/bin/pinentry -> ../Cellar/pinentry/1.1.0_1/bin/pinentry
lrwxr-xr-x  1 scottmacgregor  admin  46 Oct 28 21:21 /usr/local/bin/pinentry-curses -> ../Cellar/pinentry/1.1.0_1/bin/pinentry-curses
lrwxr-xr-x  1 scottmacgregor  admin  45 Dec 28 13:26 /usr/local/bin/pinentry-mac -> ../Cellar/pinentry-mac/0.9.4/bin/pinentry-mac
lrwxr-xr-x  1 scottmacgregor  admin  43 Oct 28 21:21 /usr/local/bin/pinentry-tty -> ../Cellar/pinentry/1.1.0_1/bin/pinentry-tty
```

A pure cli experience on servers

```
echo "pinentry-program /usr/bin/pinentry-tty" >> ~/.gnupg/gpg-agent.conf
```

For *debian/ubuntu* 

```
sudo update-alternatives --config pinentry
gpg-connect-agent reloadagent /bye
```

For *macos/OSX* you can use a GUI/popup which also works with `keychain`

```
brew install pinentry-mac
echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
```

Reload the GPG Agent (or killit to force a restart)
```
gpg-connect-agent reloadagent /bye
# killall gpg-agent
```

Note (This was seen as require at least on **macos**): 

`export GPG_TTY=$(tty)` to my `~/.bashrc`

*** PLEASE DO NOT DO THIS.. To kick the can *** 

<s>` gpg --no-tty --batch --passphrase "$GPG_PASSPHRASE" --pinentry-mode loopback --output secrets.env --decrypt ~/.bash_secrets `</s>

### Example:
```
$> env |grep -i SECRET_TOKEN
$> secrets-load
Please enter the passphrase to unlock the OpenPGP secret key:
"scott macgregor <shadowbq@gmail.com>"
2048-bit RSA key, ID 0123456789ABCDEF,
created 2019-12-28 (main key ID 0123456789ABCDEF).

Passphrase:
$> env |grep -i SECRET_TOKEN
SECRET_TOKEN=abcdefg12345678ZYXWV
```

### Working with your GPG Keys in more than one location.

GPG: Extract private key and import on different machine
Identify your private key by running `gpg --list-secret-keys`. 
You need the ID of your private key (second column)


Run this command to export your key: `gpg --export-secret-keys $ID > ~/.ssh/my-gpg-private-key.asc`.
Copy the key to the other machine ( scp is your friend)

`scp ~/.ssh/my-gpg-private-key.asc target:~/.ssh/.`

To import the key on the *target-server*, run `gpg --import ~/.ssh/my-gpg-private-key.asc`.

#### Ensure they are now trusted

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
gpg> save
```

## ENV from KEYCHAIN

sorah/envchain - https://github.com/sorah/envchain

envchain - set environment variables with macOS keychain or D-Bus secret service

## Bad: LUKS / Container

Mount it and unmount it into a FS. 

## Worst Option: Unsecure File Fault 

Source it from `.bash_local`, and in linux give it SELINUX labels.
(http://blog.siphos.be/2015/07/restricting-even-root-access-to-a-folder/)

```
$> ls -lZ .bash_local
-rw-------. 1 scottmacgregor  root system_u:object_r:secrets_log_t 60 Dec 27 14:53 .bash_local
```

## Not an Option

Do something really stupid!
