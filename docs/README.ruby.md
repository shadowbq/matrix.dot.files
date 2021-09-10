# Ruby

Ruby Versions: <https://www.ruby-lang.org/en/downloads/>

## Is there a Ruby virtual manager?

Yes, and its preferred setup is `RVM` already enabled in the ruby extension.

```shell
export PATH="$PATH:$HOME/.rvm/bin"                                   # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
```

* Note: During the install of RVM we `export rvm_ignore_dotfiles=yes` to ensure non-duplicate instructions.

## Setup

What do you need to install?

* gpg
* rvm
* bundler
* required gems

### RVM Setup

RVM is highly recommend to manage the Ruby versions on the machines. Matrix.dot.files prefers `RVM` over `rbenv`.

You need to install `GPG` prior to installing RVM.

* [README - Secrets](README.secrets.md)  - GPG installation and Secrets usage.

#### Caveat - macOS

GPG homebrew in macOS forces IPv6 but fails to resolve, so we disable this dirmngr function in gpg.

```shell
echo "disable-ipv6" > ~/.gnupg/dirmngr.conf
gpgconf --kill all
```

#### Install the GPG Keys

Install the maintainers public `gpg` keys (https://rvm.io/rvm/security)

`409B6B1796C275462A1703113804BB82D39DC0E3 # mpapis`
`7D2BAF1CF37B13E2069D6956105BD0E739499BDB # pkuczynski`

Fetch from the Key Server

```shell
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```

Alternatively you might want to import keys directly from our web server, although this is a less secure way:

```shell
\curl -ksSL https://rvm.io/mpapis.asc | gpg --import -
\curl -ksSL https://rvm.io/pkuczynski.asc | gpg --import - 
```

Trust the Keys

```shell
echo 409B6B1796C275462A1703113804BB82D39DC0E3:6: | gpg --import-ownertrust # mpapis@gmail.com
echo 7D2BAF1CF37B13E2069D6956105BD0E739499BDB:6: | gpg --import-ownertrust # piotr.kuczynski@gmail.com
```

#### Install RVM

```shell
export rvm_ignore_dotfiles=yes
\curl -sSL https://get.rvm.io | bash -s stable --ruby
```

### Restart your shell

**Close and Restart the shell before continuing.**

### Explore RVM environment

```shell
rvm
rvm list
rvm info
ruby --version
```

### Install a Ruby

If you do not a registered ruby version, or want another version install it now.

```shell
rvm install ruby 2.7.4
```

Ref: Ruby <https://www.ruby-lang.org/en/downloads/>

#### Bundler

You need to install `bundler` (if your RVM did not install it, or if you are going to use system rubies)

```shell
gem install bundler
```

### Installing Required Gems

Use bundler gem command `bundle` to install from the matrix.dot gems `Gemfile`

```shell
cd ~/.matrix/extensions/ruby/
bundle install
```

## Managing Default

If you want to use system by default (sometimes in macOS), and not use RVM you can do this. You might also do this if you installed the matrix.dot. gems into the system ruby.

```shell
rvm alias delete default
rvm use system
```

* Note: macOS - In 2021 - Catalina+ - System ruby(2.6.x) is no longer found by RVM (since 2.6.x is no longer maintained by RubyLang), so you need to install|make|build at least one additional version.  
* Note: macOS - In 2020 - Ruby gem executables end up linking against *similiar* `#!/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/bin/ruby` if you use system.
  
### macOS Warning

```txt
WARNING: This version of ruby is included in macOS for compatibility with legacy software.
In future versions of macOS the ruby runtime will not be available by
default, and may require you to install an additional package.
```

This means there will no longer be a system ruby in OSX at some point. RVM will be required.

## Volatility of Ruby

Ruby 2.x has seen tool turnovers, but we keep to `RVM` and `bundler`.
In 2021 - Ruby 3.x is releases with 2.7.x still supported.

## What you get in RCs for Ruby

### GemSetup

```ruby
 https://rubygems.org/
:update_sources: true
:verbose: true
gem: "--no-ri --no-rdoc "
```

### IRB Setup

```ruby
  require 'irb/completion'
  require 'irb/ext/save-history'
  require 'rubygems'
```

## Ruby Gems

Required ruby gems.

```ruby
gem "pry"
gem "pru"
gem "homesick"
gem "wirble"
gem "gist"
gem "rmate"
gem "bundler"
```

## Inspecting after install

```shell
$> which rvm
~/.rvm/bin/rvm

$> rvm list
 * ruby-2.6.3 [ x86_64 ]

# => - current
# =* - current && default
#  * - default

$> rvm info
system: 
....

$> gem list

*** LOCAL GEMS ***

bigdecimal (default: 1.4.1)
bundler (default: 1.17.2)
CFPropertyList (2.3.6)
cmath (default: 1.0.0)
coderay (1.1.3)
....
homesick (1.1.6)
....
```
