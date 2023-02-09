# Bash Style Guide

`dot.matrix` bash style guide for use when you can. Modify 3rd party stuff if you can.

## Basics

### Example

```bash
#!/usr/bin/env bash

NAME="John"
echo "Hello $NAME!"
```

### Variables

```bash
NAME="John"
echo $NAME
echo "$NAME"
echo "${NAME}!"
```

TL;DR: `set` can see shell-local variables, `env` cannot.

`set` is a built-in to the shell, so it is aware of shell-local variables (including shell functions). `env` is an independent executable; it only sees the variables that the shell passes to it (environment variables).

`a=1` is a local variable. Environment variables are created with `export a=1` or `a=1; export a`.

### String quotes

```bash
NAME="John"
echo "Hi $NAME"  #=> Hi John
echo 'Hi $NAME'  #=> Hi $NAME
```

### Shell execution

```bash
echo "I'm in $(pwd)"
```

Don't use backticks

```bash
echo "I'm bad dot.matrix code `pwd`"
```

See [Command substitution](http://wiki.bash-hackers.org/syntax/expansion/cmdsubst)

### Quick Functions

```bash
function get_name() {
  echo "John"
}

echo "You are $(get_name)"
```

See: [Functions](#functions)

### Conditional execution

```bash
git commit && git push
git commit || echo "Commit failed"
```

### Conditionals Tests

```bash
if [[ -z "$string" ]]; then
  echo "String is empty"
elif [[ -n "$string" ]]; then
  echo "String is not empty"
fi
```

See: [Conditionals](#conditionals)

### Strict mode

```bash
set -euo pipefail
IFS=$'\n\t'
```

Setting IFS (Internal Field Separator) to `$'\n\t'` means that word splitting will happen only on newlines and tab characters. This very often produces useful splitting behavior. By default, bash sets this to `$' \n\t'` - space, newline, tab - which is too eager.

#### Debug CI/CD mode:

Harsh binding and `-x` (`set -o xtrace`) added for debug printing

```bash
#!/usr/local/bin/env bash
set -euxo pipefail
IFS=$'\n\t'
```

See: [Unofficial bash strict mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)

[Futher Reading with TRAPS](https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/)

### Brace expansion

```bash
echo {A,B}.js
```
| Code | Description |
| --- | --- |
| `{A,B}` | Same as `A B` |
| `{A,B}.js` | Same as `A.js B.js` |
| `{1..5}` | Same as `1 2 3 4 5` |

See: [Brace expansion](http://wiki.bash-hackers.org/syntax/expansion/brace)

## Parameter expansions

### Parameter Basics

```bash
name="John"
echo ${name}
echo ${name/J/j}    #=> "john" (substitution)
echo ${name:0:2}    #=> "Jo" (slicing)
echo ${name::2}     #=> "Jo" (slicing)
echo ${name::-1}    #=> "Joh" (slicing)
echo ${name:(-1)}   #=> "n" (slicing from right)
echo ${name:(-2):1} #=> "h" (slicing from right)
echo ${name:1}      #=> "ohn" strip the J
if [[ ${name:0:1} =~ [jJ] ]] ; then name="${name:1}"; fi #=> if first letter matches j or J strip the J from $name and store "ohn". (useful for v for version tags v1.0.1, etc)
```

```bash
length=2
echo ${name:0:length}  #=> "Jo"
```

See: [Parameter expansion](http://wiki.bash-hackers.org/syntax/pe) [GNU Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)

```bash
STR="/path/to/foo.cpp"
echo ${STR%.cpp}    # /path/to/foo
echo ${STR%.cpp}.o  # /path/to/foo.o

echo ${STR##*.}     # cpp (extension)
echo ${STR##*/}     # foo.cpp (basepath)

echo ${STR#*/}      # path/to/foo.cpp
echo ${STR##*/}     # foo.cpp

echo ${STR/foo/bar} # /path/to/bar.cpp
```

```bash
STR="Hello world"
echo ${STR:6:5}   # "world"
echo ${STR:-5:5}  # "world"
```

```bash
SRC="/path/to/foo.cpp"
BASE=${SRC##*/}   #=> "foo.cpp" (basepath)
DIR=${SRC%$BASE}  #=> "/path/to/" (dirpath)
```

Used with `set -u` for safe printing of possible unset variables.

Recommend the use `:-` over `-` to handle `null` values.

```bash
echo "variable ${name-}" #=> Expand to '' when name is unset, and the value of name when name has a value.
echo "variable ${name:-}" #=> Expand to '' when name is either unset or null, and the value of name when name has a value. 
```

### Substitution

| Code | Description |
| --- | --- |
| `${FOO%suffix}` | Remove suffix |
| `${FOO#prefix}` | Remove prefix |
| --- | --- |
| `${FOO%%suffix}` | Remove long suffix |
| `${FOO##prefix}` | Remove long prefix |
| --- | --- |
| `${FOO/from/to}` | Replace first match |
| `${FOO//from/to}` | Replace all |
| --- | --- |
| `${FOO/%from/to}` | Replace suffix |
| `${FOO/#from/to}` | Replace prefix |

### Comments

```bash
# Single line comment
```

Ensure there is a space

```bash
: '
This is a
multi line
comment
'
```

### Substrings

| Code | Description |
| --- | --- |
| `${FOO:0:3}`  | Substring _(position, length)_ |
| `${FOO:-3:3}` | Substring from the right |

### Length

| Code | Description |
| --- | --- |
| `${#FOO}` | Length of `$FOO` |

### StringCase Manipulation

* Note: Bash 4.0 requirements 

```bash
STR="HELLO WORLD!"
echo ${STR,}   #=> "hELLO WORLD!" (lowercase 1st letter)
echo ${STR,,}  #=> "hello world!" (all lowercase)

STR="hello world!"
echo ${STR^}   #=> "Hello world!" (Capitalize/uppercase 1st letter)
echo ${STR^^}  #=> "HELLO WORLD!" (all uppercase)
```

Bash 3.x with `tr`

```
STR="hello world!"
echo "$(tr '[:lower:]' '[:upper:]' <<< ${STR:0:1})${STR:1}" #=> "Hello world!" (Capitalize/uppercase 1st letter)
```

### Default values

| Code | Description |
| --- | --- |
| `${FOO-val}`        | Use `$FOO`, or `val` if not set |
| `${FOO:-val}`        | Use `$FOO`, or `val` if not set or null |
| `${FOO:=val}`        | Set `$FOO` to `val` if not set or null |
| `${FOO:+val}`        | `val` if `$FOO` is set |
| `${FOO:?message}`    | Show error message and exit if `$FOO` is not set |

The `:` is optional (eg, `${FOO=word}` works)

```bash
echo ${food:-Cake}     #=> $food or default to "Cake" if $food undefined.
fruit=${food:-Apple}   #=> fruit is assigned $food or default to "Apple" if $food undefined.
empty_string=${some_undefined_var:-} #=> To make the default an empty string, use ${VARNAME:-}
```

### MetaAccess to Variable Names

```shell
${!prefix*}
${!prefix@}
```

Expands to the names of variables whose names begin with prefix, separated by the first character of the `IFS` special variable. When ‘@’ is used and the expansion appears within double quotes, each variable name expands to a separate word. Note the difference as there is no use of the `bracket`.

```shell
for var in ${!myprefix@}; do
  # print variables like myprefixStore1, myprefixStore2, myprefixFoo  
  printf "%s%q\n" "$var: " "${!var}"
done
>> myprefixStore1: Woot
>> myprefixStore2: Baz
>> myprefixFoo: Bat
```

Note: This does ***not*** register arrays and dictionary with `declare`, so accessing arrays is tricky.

## Loops

### Basic for loop

```bash
for i in /etc/rc.*; do
  echo $i
done
```

### C-like for loop

```bash
for ((i = 0 ; i < 100 ; i++)); do
  echo $i
done
```

### Ranges

```bash
for i in {1..5}; do
  echo "Welcome $i"
done
```

#### With step size

```bash
for i in {5..50..5}; do
  echo "Welcome $i"
done
```

### Reading lines

```bash
< file.txt | while read line; do
  echo $line
done
```

### Forever

```bash
while true; do
  ···
done
```

### Break / Continue

The `break` command is used to exit from any loop, like the `while` and the `until` loops.  

The `continue` command to stop executing the remaining commands inside a loop without exiting the loop.  

```bash
for number in 10 11 12 13 14 15; do
  if [[ $number -eq 11 ]]; then
    continue
  elif [[ $number -eq 14 ]]; then
    break
  fi
  echo "Number: $number"
done
#=> 10 12 13
```



## Functions

`function echo_warn() {}` or `function echo_warn {}`

Opinion: Do use parenthesis, and do use "function" keyword.
The function keyword is extraneous when "()" is present after the function name, but enhances quick identification of functions.

Bowing to `shfmt` tool wanting () even if there is a `function`. This is an not an actual historical track but one which came from portability merging.

* <https://github.com/mvdan/sh/blob/e3d6f0b10cf97c613f8ff79bcf84809d5ad7c05a/syntax/parser_test.go#L1495>

### Defining functions

```bash
function myfunc() {
  echo "hello $1"
}
```

```bash
myfunc "John"
```

### Returning values

```bash
function myfunc() {
  local myresult='some value'
  echo $myresult
}
```

```bash
result="$(myfunc)"
```

### Returning early from a function

To end the function stack without exiting shell

Use `return` instead of `exit`. `kill` with interrupt (aka `ctrl-c`) can be caught by bash.

```bash
kill -INT $$
```

### Raising errors

```bash
function myfunc() {
  return 1
}
```

```bash
if myfunc; then
  echo "success"
else
  echo "failure"
fi
```

### Arguments

| Expression | Description                        |
| ---        | ---                                |
| `$#`       | Number of arguments                |
| `$*`       | All arguments                      |
| `$@`       | All arguments, starting from first |
| `$1`       | First argument                     |

See [Special parameters](http://wiki.bash-hackers.org/syntax/shellvars#special_parameters_and_shell_variables).

## Conditionals

### Conditions

Note that `[[` is actually a command/program that returns either `0` (true) or `1` (false). Any program that obeys the same logic (like all base utils, such as `grep(1)` or `ping(1)`) can be used as condition, see examples.

| Condition                | Description           |
| ---                      | ---                   |
| `[[ -z STRING ]]`        | Empty string          |
| `[[ -n STRING ]]`        | Not empty string      |
| `[[ STRING == STRING ]]` | Equal                 |
| `[[ STRING != STRING ]]` | Not Equal             |
| ---                      | ---                   |
| `[[ NUM -eq NUM ]]`      | Equal                 |
| `[[ NUM -ne NUM ]]`      | Not equal             |
| `[[ NUM -lt NUM ]]`      | Less than             |
| `[[ NUM -le NUM ]]`      | Less than or equal    |
| `[[ NUM -gt NUM ]]`      | Greater than          |
| `[[ NUM -ge NUM ]]`      | Greater than or equal |
| ---                      | ---                   |
| `[[ STRING =~ STRING ]]` | Regexp                |
| ---                      | ---                   |
| `(( NUM < NUM ))`        | Numeric conditions    |

| Condition              | Description              |
| ---                    | ---                      |
| `[[ -o noclobber ]]`   | If OPTIONNAME is enabled |
| ---                    | ---                      |
| `[[ ! EXPR ]]`         | Not                      |
| `[[ X ]] && [[ Y ]]`   | And                      |
| `[[ X ]] || [[ Y ]]`   | Or                       |

### File conditions

| Condition               | Description             |
| ---                     | ---                     |
| `[[ -e FILE ]]`         | Exists                  |
| `[[ -r FILE ]]`         | Readable                |
| `[[ -h FILE ]]`         | Symlink                 |
| `[[ -d FILE ]]`         | Directory               |
| `[[ -w FILE ]]`         | Writable                |
| `[[ -s FILE ]]`         | Size is > 0 bytes       |
| `[[ -f FILE ]]`         | File                    |
| `[[ -x FILE ]]`         | Executable              |
| ---                     | ---                     |
| `[[ FILE1 -nt FILE2 ]]` | 1 is more recent than 2 |
| `[[ FILE1 -ot FILE2 ]]` | 2 is more recent than 1 |
| `[[ FILE1 -ef FILE2 ]]` | Same files              |

### Example Conditionals

```bash
# String
if [[ -z "$string" ]]; then
  echo "String is empty"
elif [[ -n "$string" ]]; then
  echo "String is not empty"
fi
```

```bash
# Chained
[[ -n $myvar ]] && echo 'true the var exists' || echo 'false if does not exists'
[[ -z $myvar ]] && echo 'true it is null' || echo 'false is not null'
[[ $myvar = '' ]] && echo true is empty || echo 'false is not empty'
[[ $myvar = 'something' ]] && echo 'true matches string' || echo 'false does not match string'
```

```bash
# Combinations
if [[ X ]] && [[ Y ]]; then
  ...
fi
```

```bash
# Equal
if [[ "$A" == "$B" ]]
```

```bash
# Regex
if [[ "A" =~ . ]]
```

```bash
if (( $a < $b )); then
  echo "$a is smaller than $b"
fi
```

```bash
if [[ -e "file.txt" ]]; then
  echo "file exists"
fi
```

### Truth Chart of Bash Tests

```bash
      | [       [ "     [ -n    [ -n "  [ -z    [ -z " | [[      [[ "    [[ -n   [[ -n " [[ -z   [[ -z "
------+------------------------------------------------+------------------------------------------------
unset | false   false   true    false   true    true   | false   false   false   false   true    true
null  | false   false   true    false   true    true   | false   false   false   false   true    true
space | false   true    true    true    true    false  | true    true    true    true    false   false
zero  | true    true    true    true    false   false  | true    true    true    true    false   false
digit | true    true    true    true    false   false  | true    true    true    true    false   false
char  | true    true    true    true    false   false  | true    true    true    true    false   false
hyphn | true    true    true    true    false   false  | true    true    true    true    false   false
two   | -err-   true    -err-   true    -err-   false  | true    true    true    true    false   false
part  | -err-   true    -err-   true    -err-   false  | true    true    true    true    false   false
Tstr  | true    true    -err-   true    -err-   false  | true    true    true    true    false   false
Fsym  | false   true    -err-   true    -err-   false  | true    true    true    true    false   false
T=    | true    true    -err-   true    -err-   false  | true    true    true    true    false   false
F=    | false   true    -err-   true    -err-   false  | true    true    true    true    false   false
T!=   | true    true    -err-   true    -err-   false  | true    true    true    true    false   false
F!=   | false   true    -err-   true    -err-   false  | true    true    true    true    false   false
Teq   | true    true    -err-   true    -err-   false  | true    true    true    true    false   false
Feq   | false   true    -err-   true    -err-   false  | true    true    true    true    false   false
Tne   | true    true    -err-   true    -err-   false  | true    true    true    true    false   false
Fne   | false   true    -err-   true    -err-   false  | true    true    true    true    false   false
```

**Note:** `bash-var-test-chart` will print this output. 

## Arrays

### Defining arrays

```bash
Fruits=('Apple' 'Banana' 'Orange')
```

```bash
Fruits[0]="Apple"
Fruits[1]="Banana"
Fruits[2]="Orange"
```

### Working with arrays

```bash
echo ${Fruits[0]}           # Element #0
echo ${Fruits[@]}           # All elements, space-separated
echo ${#Fruits[@]}          # Number of elements
echo ${#Fruits}             # String length of the 1st element
echo ${#Fruits[3]}          # String length of the Nth element
echo ${Fruits[@]:3:2}       # Range (from position 3, length 2)
```

### Operations

```bash
Fruits=("${Fruits[@]}" "Watermelon")    # Push
Fruits+=('Watermelon')                  # Also Push
Fruits=( ${Fruits[@]/Ap*/} )            # Remove by regex match
unset Fruits[2]                         # Remove one item
Fruits=("${Fruits[@]}")                 # Duplicate
Fruits=("${Fruits[@]}" "${Veggies[@]}") # Concatenate
lines=(`cat "logfile"`)                 # Read from file
```

### Array Iterators

```bash
for i in "${arrayName[@]}"; do
  echo $i
done
```

### Array Contains

```bash
if [[ " ${array[@]} " =~ " ${value} " ]]; then
  # whatever you want to do when arr contains value
fi

if [[ ! " ${array[@]} " =~ " ${value} " ]]; then
  # whatever you want to do when arr doesn't contain value
fi
```

**Note**: `IFS` space settings can lead to false positives: <https://stackoverflow.com/a/15394738/1569557>

## Dictionaries

### Defining

```bash
declare -A sounds
```

```bash
sounds[dog]="bark"
sounds[cow]="moo"
sounds[bird]="tweet"
sounds[wolf]="howl"
```

Declares `sound` as a Dictionary object (aka associative array).

### Working with dictionaries

```bash
echo ${sounds[dog]} # Dog's sound
echo ${sounds[@]}   # All values
echo ${!sounds[@]}  # All keys
echo ${#sounds[@]}  # Number of elements
unset sounds[dog]   # Delete dog
```

### Iteration

#### Iterate over values

```bash
for val in "${sounds[@]}"; do
  echo $val
done
```

#### Iterate over keys

```bash
for key in "${!sounds[@]}"; do
  echo $key
done
```

## Options

### Set Options

Counter-intuitive: `set -flag` enables, while `set +flag` disables  

```bash
set -e            # instructs bash to immediately exit on failure
set -u            # immediately exit on undefined/unbound variables ( set $someVar="" or  ${someVar:-} )
set -v            # Display shell input lines as they are read.
set -n            # Read commands but do not execute them. This may be used to check a shell script for syntax errors.
set -x            # Display commands and their arguments as they are executed.

set -o noclobber  # Avoid overlay files (echo "hi" > foo)
set -o errexit    # (-e) Used to exit upon error, avoiding cascading errors
set -o pipefail   # Unveils hidden failures
set -o nounset    # (-u) Exposes unset variables
```

The current set of options may be found in `$-`

Ref: <https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html>

### Glob options

```bash
shopt -s nullglob    # Non-matching globs are removed  ('*.foo' => '')
shopt -s failglob    # Non-matching globs throw errors
shopt -s nocaseglob  # Case insensitive globs
shopt -s dotglob     # Wildcards match dotfiles ("*.sh" => ".foo.sh")
shopt -s globstar    # Allow ** for recursive matches ('lib/**/*.rb' => 'lib/a/b/c.rb')
```

Set `GLOBIGNORE` as a colon-separated list of patterns to be removed from glob
matches.

## History

### Commands

| Code | Description |
| --- | --- |
| `history` | Show history |
| `shopt -s histverify` | Don't execute expanded result immediately |

### Expansions on History

| Condition                | Description           |
| ---                      | ---                   |
| `!$` | Expand last parameter of most recent command |
| `!*` | Expand all parameters of most recent command |
| `!-n` | Expand `n`th most recent command |
| `!n` | Expand `n`th command in history |
| `!<command>` | Expand most recent invocation of command `<command>` |

### Operations on History

| Condition                | Description           |
| ---                      | ---                   |
| `!!` | Execute last command again |
| `!!:s/<FROM>/<TO>/` | Replace first occurrence of `<FROM>` to `<TO>` in most recent command |
| `!!:gs/<FROM>/<TO>/` | Replace all occurrences of `<FROM>` to `<TO>` in most recent command |
| `!$:t` | Expand only basename from last parameter of most recent command |
| `!$:h` | Expand only directory from last parameter of most recent command |

`!!` and `!$` can be replaced with any valid expansion.

### Slices on History

| Condition                | Description           |
| ---                      | ---                   |
| `!!:n` | Expand only `n`th token from most recent command (command is `0`; first argument is `1`) |
| `!^` | Expand first argument from most recent command |
| `!$` | Expand last token from most recent command |
| `!!:n-m` | Expand range of tokens from most recent command |
| `!!:n-$` | Expand `n`th token to last from most recent command |

`!!` can be replaced with any valid expansion i.e. `!cat`, `!-2`, `!42`, etc.

## Miscellaneous

### Numeric calculations

```bash
$((a + 200))      # Add 200 to $a
```

```bash
$((RANDOM%=200))  # Random number 0..200
```

### Subshells

```bash
(cd somedir; echo "I'm now in $PWD")
pwd # still in first directory
```

### Redirection

```bash
hello.py > output.txt   # stdout to (file)
hello.py >> output.txt  # stdout to (file), append
hello.py 2> error.log   # stderr to (file)
hello.py 2>&1           # stderr to stdout
hello.py 2>/dev/null    # stderr to (null)
hello.py &>/dev/null    # stdout and stderr to (dev/null)
foo.py >/dev/null 2>&1  # stdout and stderr to (dev/null)

stderr_echo.py 2>&1 | grep my_err #stderr to stdout, grep my_err from stdout
```

```bash
python hello.py < foo.txt      # feed foo.txt to stdin for python
```


### Inspecting commands

```bash
command -V cd
#=> "cd is a function/alias/whatever"
```

### Trap errors

```bash
trap 'echo Error at about $LINENO' ERR
```

or

```bash
traperr() {
  echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

set -o errtrace
trap traperr ERR
```

When a signal for which a `trap` has been set is received while the shell is waiting for the completion of a utility executing a foreground command, the trap associated with that signal shall not be executed until after the foreground command has completed.

```bash
#!/bin/bash
echo "Setting trap"
trap 'ctrl_c' INT
function ctrl_c() {
  echo "CTRL+C pressed"
  exit
}
sleep 1000
```

This means that `sleep` will need to finish if `ctrl-c` is captured during execution of `sleep`.

Send `kill -INT` (-2) to the process/PID you want to stop, here `sleep` to exit early.

```bash
ps -f -o pid,ppid,pgid,tty,comm -t pts/1
  PID  PPID  PGID TT       COMMAND
 3460  3447  3460 pts/1    bash
29087  3460 29087 pts/1     \_ foo.sh
29120 29087 29087 pts/1         \_ sleep

$ kill -2 -29087
```

### Case/switch

```bash
case "$1" in
  start | up)
    vagrant up
    ;;

  *)
    echo "Usage: $0 {start|stop|ssh}"
    ;;
esac
```

Case switch on file mime-type using `file` tool.

```bash
for file in *; do
  case $(file --mime-type -b "$file") in
    image/*g)        ... ;;
    text/plain)      ... ;;
    application/xml) ... ;;
    application/zip) ... ;;
    *)               ... ;;
  esac
done
```

Similar `if/else/fi` example .. (truncated)

```bash
if [[ $(file --mime-type -b "$file") == image/*g ]]; then
...
elif [[ $(file --mime-type -b "$file") == text/plain ]]; then 
...
fi 
```

### Source relative

```bash
source "${0%/*}/../share/foo.sh"
```

**Note**: "The single `.` source pattern is very hard to grep."

### printf

```bash
printf "Hello %s, I'm %s" Sven Olga
#=> "Hello Sven, I'm Olga

printf "1 + 1 = %d" 2
#=> "1 + 1 = 2"

printf "This is how you print a float: %f" 2
#=> "This is how you print a float: 2.000000"
```

### Directory of script

```bash
DIR="${0%/*}"
```

### Getting options

```bash
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -V | --version )
    echo $version
    exit
    ;;
  -s | --string )
    shift; string=$1
    ;;
  -f | --flag )
    flag=1
    ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi
```

### Heredoc

```bash
cat <<END
hello world
END
```

```bash
cat <<'HEREDOC' >> .my_config
this will not ${expand} variables
so use it for appending blocks of
config files together
HEREDOC
```

<http://tldp.org/LDP/abs/html/here-docs.html>

### Reading input

```bash
echo -n "Proceed? [y/n]: "
read ans
echo $ans
```

```bash
read -n 1 ans    # Just one character
```

### Special variables

| Condition                | Description           |
| ---                      | ---                   |
| `$?` | Exit status of last task |
| `$!` | PID of last background task |
| `$$` | PID of shell |
| `$0` | Filename of the shell script |

See [Special parameters](http://wiki.bash-hackers.org/syntax/shellvars#special_parameters_and_shell_variables).

### Go to previous directory

```bash
pwd #=> /var/log/
cd ~
pwd #=> /home/username/
cd -
pwd #=> /var/log/
```

### Check for command's result

```bash
if ping -c 1 google.com; then
  echo "It appears you have a working internet connection"
fi
```

### Grep check

```bash
if grep -q 'foo' ~/.bash_history; then
  echo "You appear to have typed 'foo' in the past"
fi
```

### Search for multiple strings in a file

Do this.. two different regex patterns searching `*.txt`

```bash
grep -e foo -e bar -- *.txt
```

(Also note the `--` end-of-option-marker to stop some grep implementations including GNU grep from treating a file called -foo-.txt for instance (that would be expanded by the shell from *.txt) to be taken as an option even though it follows a non-option argument here).

Ref: <https://unix.stackexchange.com/a/37316/104660>

The below is slow and memory hog.

```bash
# Loads a ton into memory. boo.
declare file="~/.gitconfig"
declare regex="\s+string\s+"

declare file_content=$( cat "${file}" )
if [[ " $file_content " =~ $regex ]] # please note the space before and after the file content
  then
    echo "found"
  else
    echo "not found"
fi
```

## Use of Sed and Awk

**Note:** `sed` and `gsed` across the gplv2 (macos) and gplv3 (linux,homebrew) have many regex match differences, but if you are careful you can use them. 

We can use variables in `sed` using double quotes:

```bash
sed -i "s/$var/r_str/g" file_name
```

If you have a slash `/` in the variable then use different separator, like below:

```bash
sed -i "s|$var|r_str|g" file_name
```

You can use wrapper functions to help with checks and `sed -i`

```
function is_gnu_sed() {
    sed --version >/dev/null 2>&1
}

function sed_i_wrapper() {
    if is_gnu_sed; then
        $(which sed) "$@"
    else
        a=()
        for b in "$@"; do
            [[ $b == '-i' ]] && a=("${a[@]}" "$b" "") || a=("${a[@]}" "$b")
        done
        $(which sed) "${a[@]}"
    fi
}
```

## Templates

### getopts

See the getopts template for commands

`.matrix/opt/templates/bash_getopts_template.sh`

Best explaination <https://www.computerhope.com/unix/bash/getopts.htm>

Reference: [Parsing getopts](https://sookocheff.com/post/bash/parsing-bash-script-arguments-with-shopts/) & Why [getopts and not getopt](http://abhipandey.com/2016/03/getopt-vs-getopts/).

### Tests

So, don't use `which`. Instead use one of these:

```bash
$> command -v foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
$> type foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
```

```bash
if [[ $(command -v jq) ]]; then
  echo "jq is available"
fi
```

## Bash Unit Test

### Shellcheck

Shellcheck is a bash style, and bestpractice linter. Use it extensively.

<https://github.com/koalaman/shellcheck> 

### Precommit

The use of precommit with shellcheck is highly recommended.

```yaml
- repo: https://github.com/jumanjihouse/pre-commit-hooks
  rev: 1.11.2
  hooks:
  - id: shellcheck
    stages: [commit]
    args: ["-e", "SC1091"]
```

### Bats

<https://github.com/ztombol/bats-docs>

<https://github.com/jasonkarns/bats-assert-1>

```shell
bats "${_PROJECT_ROOT}/test/test_main.bats" 3>&1
```

```shell
load 'bats-support/load.bash'
load 'bats-assert/load.bash'
load 'bats-file/load.bash'

_PROJECT_ROOT=${_PROJECT_ROOT:?}
generic_help='Usage myapp'

@test "show generic help" {
  cd $_PROJECT_ROOT
  run ./myapp
  assert_output -p "$generic_help"
}
```

## Bash Notations

All bash notations should be less than 80 characters wide.

### LICENSES

```shell
<<LICENSE
Copyright (c) 2012, shadowbq@gmail.com
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTOR BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
THE POSSIBILITY OF SUCH DAMAGE.

LICENSE
```

### Titles

`Dot.matrix` should use common descriptive headers.

```shell
##############################################################################
# check_gnu_core
#
# Check for GNU GPLV3 Coreutilities
#
## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##
# shadowbq - MIT Copyright (c) 2020
## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##
# shellcheck shell=bash
##############################################################################
```

### References

Shells should reference external knownledge when available on sources like:

```shell
## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##
# StackOverflow - https://unix.stackexchange.com/a/37316/104660
## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##
```

* Stack Overflow - Use SO url shortener
* Explain Shell
* git repo / github repo referenced from with licence.
* Rando Dudes tutorial
* etc.
