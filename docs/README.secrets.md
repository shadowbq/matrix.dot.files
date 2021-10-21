# matrix.secrets
manage secrets in bash - https://github.com/shadowbq/matrix.secrets

We should never store unecrypted secrets on our machines. ***Storing un-encrypted Secret ENVs in a file is bad idea®.***

## Table of Contents

  * [Methodology](#methodology)
  * [Usage](#usage)
  * [Implementation](#implementation)
  * [Setup](#setup)
    + [Install GPG and Init](#install-gpg-and-init)
    + [Set your pin entry method](#set-your-pin-entry-method)
  * [New Secrets - Creation Securely using RAMDisks](#new-secrets---creation-securely-using-ramdisks)
  * [GnuPG](#gnupg)
    + [Creating a new GPG Key](#creating-a-new-gpg-key)
    + [Working with Existing GPG Keys in more than one location.](#working-with-existing-gpg-keys-in-more-than-one-location)
      - [Extract private key and import on different machine](#extract-private-key-and-import-on-different-machine)
      - [Register an Existing Key](#register-an-existing-key)
      - [Trust the newly Imported key](#trust-the-newly-imported-key)
  * [Loading of Secrets - Manual Implementation](#loading-of-secrets---manual-implementation)

## Methodology

Store secrets as an RSA 2048 encrypted Base64 bash ENV file that gets decrypted in memory via GPG and sourced as needed into Bash.

## Usage

```shell
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

## Implementation 

Store secrets as ENVs on a file (`.bash_secrets`) that can be sourced from Bash, but don't write the file to the hard-drive. Instead write it RSA 2048 encrypted then Base64 as (` ~/.bash_encrypted`) and decrypt in memory and source it as needed.

It is implemented as an alias `secrets_load` which evals bash function `_secrets_decrypt` on the `~/.bash_encrypted` file using gpg keys that are pin secured.

## Setup

### Install GPG and Init

Install the GPG client

* NOTE: that on MacOS the command isn't gpg2 but rather just gpg. 

```shell
$(macOS)>  brew install gpg
$(deb/ubuntu)> apt install gnupg
$(linux/rhel)> yum install gnupg
$(bsd) > gpg
```

Init GPG

```shell
gpg --list-keys
gpg: directory '/Users/smacgregor/.gnupg' created
gpg: keybox '/Users/smacgregor/.gnupg/pubring.kbx' created
gpg: /Users/smacgregor/.gnupg/trustdb.gpg: trustdb created
```

### Set your pin entry method

You are required to have a pin entry application *that works(looking at you mac)* 

* `$(macOS)>  brew install pinentry-mac` 
* `$(deb/ubuntu)> apt install pinentry-tty`
* `$(linux/rhel)> yum install pinentry-tty`

* [SO - Install Help](https://superuser.com/questions/520980/how-to-force-gpg-to-use-console-mode-pinentry-to-prompt-for-passwords)

```shell
ls -la /usr/*/bin/pinentry*
lrwxr-xr-x  1 smacgregor  admin  39 Nov  5 09:15 /usr/local/bin/pinentry -> ../Cellar/pinentry/1.1.0_1/bin/pinentry
lrwxr-xr-x  1 smacgregor  admin  46 Nov  5 09:15 /usr/local/bin/pinentry-curses -> ../Cellar/pinentry/1.1.0_1/bin/pinentry-curses
lrwxr-xr-x  1 smacgregor  admin  45 Nov  5 09:31 /usr/local/bin/pinentry-mac -> ../Cellar/pinentry-mac/0.9.4/bin/pinentry-mac
lrwxr-xr-x  1 smacgregor  admin  43 Nov  5 09:15 /usr/local/bin/pinentry-tty -> ../Cellar/pinentry/1.1.0_1/bin/pinentry-tty
```

A pure cli experience on servers or terminal

```shell
echo "pinentry-program /usr/bin/pinentry-tty" >> ~/.gnupg/gpg-agent.conf
```

For *debian/ubuntu* you *MUST* update the alternatives

```shell
$(deb/ubuntu)> sudo update-alternatives --install /usr/bin/pinentry pinentry /usr/bin/pinentry-tty 200
```

For *macos/OSX* you can *ALTERNATIVELY* use a GUI/popup which also works with `keychain`

```shell
$(macOS)> brew install pinentry-mac
$(macOS)> echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
```

Reload the GPG Agent (or kill it to force a restart)

```shell
gpg-connect-agent reloadagent /bye
# `killall gpg-agent` if that not working correctly
```

Note (This was seen as require at least on **macos**):  

```shell
env |grep GPG
GPG_TTY=/dev/ttys001
```

else  

`export GPG_TTY=$(tty)` to my `~/.bash_local`

## New Secrets - Creation Securely using RAMDisks

Given that you have a GPG KEY `0123456789ABCDEF0123456789ABCDEF` listed as `ultimate`:

```shell
$> gpg --list-keys
/Users/scottmacgregor/.gnupg/pubring.kbx
----------------------------------------
pub   rsa2048 2019-12-28 [SC] [expires: 2021-12-27]
      0123456789ABCDEF0123456789ABCDEF
uid           [ultimate] scott macgregor <shadowbq@gmail.com>
sub   rsa2048 2019-12-28 [E] [expires: 2021-12-27]
```


Encrypt a bash script with contents: `export SECRET_TOKEN=abcdefg12345678ZYXWV` securely into `.bash_encrypted`

Option 1) 'Ensured Security' 

* https://unix.stackexchange.com/a/271870/104660)
* `tmpfs` + `luks\encryption` + `ext4` + immediate destruction

Option 2) 'Good Enough' new ramDisk + immediate destruction

```shell
# Make your Linux secrets securely 
$(linux)> mkdir -p $HOME/tmpfs
$(linux)> mount -t tmpfs -o size=512m ramfs $HOME/tmpfs

# Make your MacOS secrets securely (macos_ramdisk is in .matrix/Darwin/bin)
$(macOS)> macos_ramdisk mount
```

Example *UNENCRYPTED* `.bash_secrets` file

```shell
export SECRET_TOKEN=abcdefg12345678ZYXWV
export SECRET_CLIENT_ID=abcdefg12345678ZYXWV
export SECRET_FOO_CLIENT=abcdefg12345678ZYXWV
```

Create the `.bash_secrets` in the tmpfs

```shell
vi $HOME/tmpfs/.bash_secrets
[..Write.Secrets.here..]
cat $HOME/tmpfs/.bash_secrets | gpg --encrypt -r 0123456789ABCDEF0123456789ABCDEF --armor |base64 > ~/.bash_encrypted
```


'Good enough' Destruction of Secrets
```
$(linux)> sudo umount $HOME/tmpfs
$(macOS)> sudo macos_ramdisk umount $HOME/tmpfs
```

## GnuPG 

You can create new keys, or use existing keys across multiple machines.

### Creating a new GPG Key

`gpg --full-generate-key`

1) At the prompt, specify the kind of key you want, or press Enter to accept the default.
1) At the prompt, specify the key size you want, or press Enter to accept the default. Your key must be at least 4096 bits.
1) Enter the length of time the key should be valid. Press Enter to specify the default selection, indicating that the key doesn't expire.
1) Verify that your selections are correct.
1) Enter your user ID information.
2) Type a secure passphrase.

```txt
gpg (GnuPG) 2.3.2; Copyright (C) 2021 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (sign only)
  (14) Existing key from card
Your selection? <default>
Please select which elliptic curve you want:
   (1) Curve 25519 *default*
   (4) NIST P-384
   (6) Brainpool P-256
Your selection? <default>
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)
Key does not expire at all
Is this correct? (y/N) y
```

Validate the Key is Ultimate

```
$> gpg --list-secret-keys --keyid-format=long
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
/Users/shadowbq/.gnupg/pubring.kbx
------------------------------------
sec   ed25519/0123456789ABCDEF 2021-10-21 [SC]
      0123456789ABCDEF0123456789ABCDEF
uid                 [ultimate] scott macgregor <shadowbq@gmail.com>
ssb   cv25519/0123456789ABCDEF 2021-10-21 [E]
```

### Working with Existing GPG Keys in more than one location.

#### Extract private key and import on different machine

Identify your private key by running 

`gpg --list-secret-keys --keyid-format=LONG`.  

You need the ID of your private key (second column)  

`0123456789ABCDEF`

Run this command to export your key: 

`gpg --export-secret-keys $ID > ~/.ssh/my-gpg-private-key.asc`.  

Copy the key to the other machine ( scp is your friend)  

`scp ~/.ssh/my-gpg-private-key.asc target:~/.ssh/.`. 

#### Register an Existing Key

To import the key on the *target-server*, run 

```
$> gpg --import ~/my-gpg-private-key.asc

Please enter the passphrase to import the OpenPGP secret key:
"scott macgregor <shadowbq@gmail.com>"
256-bit EDDSA key, ID 0123456789ABCDEF,
created 2021-10-21.

Passphrase:
gpg: key 0123456789ABCDEF: secret key imported
gpg: Total number processed: 1
gpg:              unchanged: 1
gpg:       secret keys read: 1
gpg:   secret keys imported: 1
```

#### Trust the newly Imported key

Ensure the keys are correct by observing the ID with LONG format:

`gpg --list-secret-keys --keyid-format=LONG`
`gpg --list-keys --keyid-format 0xLONG`

Everything showed up as normal **except** for the uid which now reads `[unknown]`:

```shell
uid [ unknown ] User < user@useremail.com >
```

Bump that trust, because its yours!

```shell
$> gpg --edit-key user@useremail.com
gpg> trust

Please decide how far you trust this user to correctly verify other users\' keys
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

`gpg --list-keys --keyid-format 0xLONG`

```shell
uid [ ultimate ] User < user@useremail.com >
```

## Loading of Secrets - Manual Implementation

As an alternative to `secrets_load`,  you can manually decrypt and load into current `tty` ENV.

``` shell
$> eval $(cat ~/.bash_encrypted |base64 -d |gpg --decrypt 2> /dev/null)
```

## Alternatives

### Using ENV from OSX-KEYCHAIN / Linux D-Bus Services

Sorah/ENVchain allows you to secure credential environment variables to your secure vault, and set to environment variables only when you called explicitly.

sorah/envchain - https://github.com/sorah/envchain

envchain - supports macOS keychain or D-Bus secret service (gnome-keyring) 

### Bad: LUKS / Container

Mount it and unmount it into a FS.

### Worst Option: Insecure File Fault

Source it from `.bash_local`, and in linux give it SELINUX labels.
(http://blog.siphos.be/2015/07/restricting-even-root-access-to-a-folder/)

```shell
$> ls -lZ .bash_local
-rw-------. 1 scottmacgregor  root system_u:object_r:secrets_log_t 60 Dec 27 14:53 .bash_local
```

### Not an Option

Do something really stupid!
