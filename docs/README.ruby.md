# Ruby

Ruby can 2.x has seen tool turnovers, but we keep to `RVM` and `bundler`.

## Setup

What do you need to install?

* rvm --optional
* bundler
* required gems

## Is there a Ruby virtual manager?

Yes, and its preferred setup is `RVM` already enabled in the ruby extension.

```shell
export PATH="$PATH:$HOME/.rvm/bin"                                   # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
```

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
