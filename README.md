matrix.dot.files
================

entering the matrix of my maze of dot files. 

The core concept is to have a unified experience across all POSIX systems.

## Hooking into the matrix

Use an application like [homesick rubygem](https://github.com/technicalpickles/homesick) or [homeshick bash script](https://github.com/andsens/homeshick).

### Getting Started

You use the homesick command to clone a castle (the matrix):

```shell
homesick clone git://github.com/shadowbq/matrix.dot.files.git
```

Next symlink the matrix to your $HOME

```shell
homesick symlink matrix.dot.files
```

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
* Additional functions, environment needs, and mockups

### Other Files

```
.bash_bashrc
.bash_logout
```

base cross platform bash files

```
.bash_local 
```

Local file for ENV changes that are excluded from unified profile (SECRETS)

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



