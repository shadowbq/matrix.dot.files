# matrix.dot.files

A Unified Modern *Bash* Experience Across All POSIX Systems.

Enter the matrix of dot files. - [Since May 25, 2012](https://github.com/shadowbq/matrix.dot.files/tree/b98643c87094edf3807368c7e765df1fcc350d2d)

[![matrix-screenshot](docs/meta/matrix-screenshot.png)](README.md)

## Highlights

* Native `bash 3.x/4.x/5.x` supported shell.
* Language versions managers like RVM/PYENV/GVM/NVM
* Security with SSH Agents, GPG Env Secrets, and Proxies
* Essential out of the box tooling like GIT, TMUX, VIM.
* Colors and Themes with Powerline and TPM.
* Docker aware, and K8s tooling
* Sanity checks for Bash GNU gpl2 tools, built in bash functions, and matrix update consistency.

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

## Configuration (Post Install)

**Where is the main configuration of `matrix.dot.files`?**
  
* `~/.matrix_config` is where you enable or disable matrix modules/extensions(ie: go, nodejs, docker, vim etc..).

**Where do local Shell settings go?**

* Local files can be added to a singular system for individual enhancement.

```shell
.bash_local
.bash_aliases
```

* Secure files like these are ignored from the repo in the `.gitignore` by default.

```shell
.secrets
.bash_encrypted
.ssh/*.pem
.ssh/*.key
.ssh/id*
```

**How do I `ignore` or `skip` files so I don't commit them to a git repo?**

* You can ignore files using the alias `skip` to avoid errors on **matrix local consistency** checks by adding this git nugget. 
* This will allow for customization of your files away from the upstream repo.

```shell
$> git skip home/.matrix_config
$> git skip home/.ssh/ssh_config
$> git skipped
S home/.matrix_config
S home/.ssh/ssh_config
```


## The Docs

Read the Docs, as they are very helpful in getting unstuck, or installed correctly in each section.

```markdown
./README.md - The site README
```

### The Developers Opinion  

[README - Opinion](docs/README.md)  

### Operating Systems - Installation and Setup Guides for the extensions  

[README - BSD](docs/README.os.bsd.md)  
[README - LINUX](docs/README.os.linux.md)  
[README - MacOS](docs/README.os.macos.md)  
[README - Win10](docs/README.os.win10.md)  

### Languages - Installation and Setup Guides for the extensions  

[README - GoLang](docs/README.go.md)  
[README - Node.js](docs/README.nodejs.md)  
[README - Python](docs/README.python.md)  
[README - Ruby](docs/README.ruby.md)  

### Best Practices  

[README - Bash](docs/README.bash.md)  

### Controls - Installation and Setup Guides for the extensions  

[README - Git](docs/README.git.md) - Using Git (multi users etc.)  
[README - TMUX](docs/README.tmux.md) - Using TMUX  
[README - VIM](docs/README.vim.md) - My vim configurations  
[README - Powerline](docs/README.powerline.md) - Python's Powerline statusline  
[README - Proxies](docs/README.proxied.md) - Using Proxies  
[README - Secrets](docs/README.secrets.md) - Secure shell usage of Secrets  
[README - Sandboxes](docs/README.sandbox.md) - Application Sandboxing  
[README - Containers](docs/README.containers.md) - Docker and K8s  
[README - Security](docs/README.security.md) - General Security Information  
### Additional 3rd Tools Manuals  

[README - ACK](docs/tools/README.ack.md)  
[README - PrettyPrint](docs/tools/README.prettyprint.md)  
[README - RANDOMZ](docs/tools/README.randomz.md)  
[README - RMATE](docs/tools/README.rmate.md)  

## Dependencies

The Matrix has a few dependencies if you are going to use it.

* Bash
* Sane setups with gplv3-coreutils and brew on macos
* Ruby, RVM and a set of GEMs
* VI with Vundle
* TMUX with TPM bundles with Powerline Python3
* NPM with Node NVM
* Powerline 
* VIM with Airline (slimmer Powerline option)

Run the matrix dependency checker to get a good start on ensuring a SANE environment

`.matrix/bin/check_matrix_dependencies`

## File Hierarchy

### Global Directive

```shell
.bash_profile
```

bash_profile is the primary universal include directive file that autoloads dot.matrix directives

### Matrix

bash_matrix defines what additional include directives to load from the matrix (configure your load out here)

```shell
.bash_matrix
```

`.matrix` directory holds all additional plugins

* OS specific - load paths, bins, aliases, advisors
              - (./Darwin/.bash_extensions)
* Global bins - cross platform shell scripts (xpull, rmate, ssh-copy-id, epoch, etc.. )
* Rubygems in bundler format that improve experience
* Additional functions, environment needs, and mockups

### Other Files

Additional actions on the Universal Profile

```shell
.bashrc           # NOTE: Bashrc are loaded by .bash_profile!
.bash_logout      # Performed during logout.
```

Standardized `.git` configs and shortcuts

```shell
.gitconfig
.gitignore-global
```

Other .file(s) that can enhance the unified experience

```shell
.irbrc
.curlrc
.....(others)
```

## Other Directories

There are some additional directories symlinked in to assist in application normalization

```shell
.config
.parallel
.vim
```

## More Help

* For More help please the `/docs` directory/..
* File an Issue on GITHUB
* Ask on StackHUB
