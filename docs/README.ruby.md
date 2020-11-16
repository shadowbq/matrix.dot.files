# Ruby

## Is there a Ruby virtual manager?

Yes, and its preferred setup is `RVM` already enabled in the ruby extension.

```shell
export PATH="$PATH:$HOME/.rvm/bin"                                   # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
```
* Note: During the install of RVM we `export rvm_ignore_dotfiles=yes` to ensure non-duplicate instructions.

## Setup

What do you need to install?

* rvm --optional
* bundler
* required gems

### RVM Setup

#### OSX 

Install RVM on OSX requires some handholding

```shell
echo "disable-ipv6" > ~/.gnupg/dirmngr.conf
gpgconf --kill all
gpg --keyserver pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
export rvm_ignore_dotfiles=yes
\curl -sSL https://get.rvm.io | bash -s stable --ruby
```

* Note: GPG in OSX forces IPv6 but fails to resolve, so we disable this junk in gpg.

### Installing Required Gems

#### Bundler:

You need install bundler (if your RVM did not install it, or if you are going to use system rubies)

`sudo gem install bundler`

#### Matrix.Dot Gems

Use bundler gem command `bundle` to install from the matrix.dot gems `Gemfile`

```shell
cd ~/.matrix/extensions/ruby/ 
sudo bundle install
```

## Managing Default

If you want to use system by default (sometimes in OSX), and not use RVM you can do this. You might also do this if you installed the matrix.dot. gems into the system ruby.

```
rvm alias delete default
rvm use system
```

* Note: OSX - Ruby gem executables endup linking against *similiar* `#!/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/bin/ruby` if you use system.

## Volatility of Ruby

Ruby 2.x has seen tool turnovers, but we keep to `RVM` and `bundler`.

### OSX Warning

```
WARNING: This version of ruby is included in macOS for compatibility with legacy software.
In future versions of macOS the ruby runtime will not be available by
default, and may require you to install an additional package.
```

This means there will no longer be a system ruby in OSX at somepoint. RVM will be required.

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
