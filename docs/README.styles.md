# The Opinion:

*dot.matrix uses `bash`. I prefer 4.x and above! I prefer GNU Coreutils with GPLv3 (moderncore). I rarely use `sh`*

I **DO NOT** use ksh, pdksh, ash, dash, C shell (csh, tcsh), Z shell (zsh), and the Friendly Interactive Shell (fish).

I prefer DRY code when possible.

I prefer extensions and extensibility.

I prefer fancy and colorful output when possible.

I prefer shell scripts that don't require python, ruby, node, etc.

## Binaries

Binaries (x86/i386/arm/arm7/ELF/Mach-O/PE32) need to be build on the target system, so I don't use them.

## Containers

Containers.. maybe, but don't rely it. 

## Document confusing BASH Shell Code

Explain hard code with:

* `# COMMENTS`
* https://explainshell.com/explain?cmd=

## Bash Styles

Please use shellcheck https://github.com/koalaman/shellcheck

```shell
# shellcheck shell=bash
```

Ref: https://github.com/koalaman/shellcheck/wiki/SC2148

### Bash Functions

`function echo_warn {}`

Opinion: Do Not use parenthesis, and do use "function" keyword.

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

Remember to set to a BOOLEAN variable via command /usr/bin/true || /usr/bin/false not strings. **DO NOT QUOTE false!**

### INI Option replacement

Search for INI value and replace it:

`grep -q '^option' file && sed -i 's/^option.*/option=value/' file || echo 'option=value' >> file`

## References:

Man Bash 3.x Builtins: https://linux.die.net/man/1/bash