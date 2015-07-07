matrix.dot.files
================

entering the matrix of my maze of dot files. 

```
101 1010 101010 0100100 10010 001 10101 101010 01
.10 0100 0101010.00 101 10110 010 01.10 010010 01
01001 101 0.1 10110 010 10100 0010 0100100 10..10
00101 010100101 010  10101 10 0.01 1001101 001010
 0101 1010 0010 101  00100 01 0101 011 101 1.0100
 .101 1010 1100 011.0 0010 00.1010 000 010 010 00
 01010.010 01.01 0100 0100 00101010010 001 100 10
 01 101010 10 11 0010  100 00001  1 0 01101 10 01
001 100101 .0 01.0100  1 0101 01. 1 01 101 00  00
001 100 01010 000 110.10  011 000 01001100 10 101
001 101 010010010 000100 1001 101 0101 100.11 0.0
```

The core concept is to have a unified experience across all POSIX systems.

## Hooking into the matrix

Use an application like [homesick rubygem](https://github.com/technicalpickles/homesick) or [homeshick bash script](https://github.com/andsens/homeshick).

### Getting Started

You use the homesick command to clone a castle (the matrix):

```shell
homesick clone git://github.com/shadowbq/matrix.dot.files.git
```
-or-
```
homesick clone https://github.com/shadowbq/matrix.dot.files.git
```

Next symlink the matrix to your $HOME

```shell
homesick symlink matrix.dot.files
```

Note: you may not want to accept the (.ssh) directory.

Show the available castles:

```shell
homesick list
```

## File Hierarchy

### Global Directive

```
.bash_profile
```

bash_profile is the primary universal include directive file that autoloads .matrix directives 


### Matrix

```
.bash_matrix
```
bash_matrix defines what additional include directives to load from the matrix (configure your load out here)

```
.matrix 
```
matrixdirectory holds all additional plugins 

* OS specific - load paths, bins, aliases, advisors
              - (./Darwin/.bash_extensions)
* Global bins - cross platform shell scripts (xpull, rmate, ssh-copy-id, epoch, etc.. )
* Rubygems in bundler format that improve experience
* Additional functions, environment needs, and mockups

### Other Files

```
.bashrc
.bash_logout
```

Base cross platform bash files (defaults in .bashrc)

```
.bash_local 
.secrets
```

Local files for ENV changes that are excluded from unified profile (SECRETS)

```
.gitconfig
.gitignore-global
```

Standardized .git configs 

```
.irbrc
.curlrc
.....(others)
```

Other .file(s) that can enhance the unified experience



