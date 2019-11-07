# matrix.dot.files

Enter the matrix of dot files. 

[![asciicast](docs/matrix_asciinema.png)](https://asciinema.org/a/9scvu667GH2hCvO1aAlPl1cww?autoplay=1)

The core concept is to have a unified modern experience across all POSIX systems.

## Hooking into the matrix

Use an application like [homesick rubygem](https://github.com/technicalpickles/homesick) or [homeshick bash script](https://github.com/andsens/homeshick).

### Getting Started

You use the homesick command to clone a castle (the matrix):

```shell
homesick clone git://github.com/shadowbq/matrix.dot.files.git
```

-or-

```shell
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

## Dependencies

The Matrix has a few dependencies if you are going to use it.

* Sane setups with gplv3-coreutils and brew on macos
* Ruby, RVM and a set of GEMs
* VI with Vundle 
* TMUX with TPM bundles with Powerline Python3
* NPM with Node NVM
* Bash with Airline (slimmer Powerline option)

Run the matrix dependency checker to get a good start on ensuring a SANE environment

`.matrix/install/check_matrix_dependencies`


## File Hierarchy

### Global Directive

```shell
.bash_profile
```

bash_profile is the primary universal include directive file that autoloads .matrix directives 

### Matrix

```shell
.bash_matrix
```

bash_matrix defines what additional include directives to load from the matrix (configure your load out here)

```shell
.matrix
```

matrixdirectory holds all additional plugins 

* OS specific - load paths, bins, aliases, advisors
              - (./Darwin/.bash_extensions)
* Global bins - cross platform shell scripts (xpull, rmate, ssh-copy-id, epoch, etc.. )
* Rubygems in bundler format that improve experience
* Additional functions, environment needs, and mockups

### Other Files

```shell
.bashrc
.bash_logout
```

Base cross platform bash files (defaults in .bashrc)

```shell
.bash_local
.secrets
```

Local files for ENV changes that are excluded from unified profile (SECRETS)

```shell
.gitconfig
.gitignore-global
```

Standardized .git configs 

```shell
.irbrc
.curlrc
.....(others)
```

Other .file(s) that can enhance the unified experience
