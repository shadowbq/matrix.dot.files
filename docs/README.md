# The Opinion

*dot.matrix uses `bash`. I prefer 4.x and above! I prefer GNU Coreutils with GPLv3 (moderncore). I rarely use `sh`*

I **DO NOT** use ksh, pdksh, ash, dash, C shell (csh, tcsh), Z shell (zsh), and the Friendly Interactive Shell (fish).

I prefer DRY code when possible.

I prefer extensions and extensibility.

I prefer fancy and colorful output when possible.

I prefer shell scripts that don't require python, ruby, node, etc.

I agree with many concepts in https://google.github.io/styleguide/shell.xml but not all, see refer to `README.bash.md` for style guide.

## Binaries

Binaries (x86/i386/arm/arm7/ELF/Mach-O/PE32) need to be build on the target system, so I don't use them.

## Containers

Containers.. maybe, but don't rely it. 

## Document confusing BASH Shell Code

Explain hard code with:

* `# COMMENTS`
* https://explainshell.com/explain?cmd=

## Bash Styles

Refer to `README.bash.md` for style guide.

Please use shellcheck https://github.com/koalaman/shellcheck

```shell
# shellcheck shell=bash
```

Ref: https://github.com/koalaman/shellcheck/wiki/SC2148

### Bash

#### Command Substitution

Command substitution allows the output of a command to be substituted in place of the command name itself.:

`$(command)`

Avoid the use of `backticks`.

The syntax of the shell command language has an ambiguity for expansions beginning with "$((", which can introduce an arithmetic expansion or a command substitution that starts with a subshell. Arithmetic expansion has precedence; that is, the shell shall first determine whether it can parse the expansion as an arithmetic expansion and shall only parse the expansion as a command substitution if it determines that it cannot parse the expansion as an arithmetic expansion. The shell need not evaluate nested expansions when performing this determination. If it encounters the end of input without already having determined that it cannot parse the expansion as an arithmetic expansion, the shell shall treat the expansion as an incomplete arithmetic expansion and report a syntax error. A conforming application shall ensure that it separates the "$(" and '(' into two tokens (that is, separate them with white space) in a command substitution that starts with a subshell. For example, a command substitution containing a single subshell could be written as:

`$( (command) )`

#### Arithmetic Expansion

Arithmetic expansion provides a mechanism for evaluating an arithmetic expression and substituting its value. The format for arithmetic expansion shall be as follows:

`$((expression))`

### Colored Console functions()

```shell
echo_notify "printed in GREEN to STDERR"  
echo_warn "printed in YELLOW to STDERR"   
echo_err "printed in RED to STDERR"  
echo_info "printed in BLUE to STDERR"  
echo_debug "printed in GRAY to STDERR if ENV: MATRIX_DEBUG set"  
```

### Grep with Regex

Also, you need to tell grep to use extended regular expressions.

`$ grep -E '(then|there)' x.x`

Without extended regular expressions, you have to escape the |, (, and ). Note that we use single quotation marks here. Bash treats backslashes within double quotation marks specially.

`$ grep '\(then\|there\)' x.x`

### Username

https://www.cyberciti.biz/faq/howto-get-group-name-in-linux/

### Testing in Bash

dot.matrix is for userspace consistency, not service consistency. dot.matrix isn't needed for alpine or coreos.  

`[[` works only in Bash, Zsh and the Korn shell, and is more powerful; `[` and `test` are available in POSIX shells. 
But its 2020.. so.. bash is available for userspace on all linux, macos, freebsd, even windows 10 on WSL. 

Remember to set to a BOOLEAN variable via command /usr/bin/true || /usr/bin/false not strings. **DO NOT QUOTE false!**

### INI Option replacement

Search for INI value and replace it:

`grep -q '^option' file && sed -i 's/^option.*/option=value/' file || echo 'option=value' >> file`

## References:

Man Bash 3.x Builtins: https://linux.die.net/man/1/bash
