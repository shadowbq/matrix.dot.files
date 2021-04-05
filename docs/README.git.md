# GIT

`git` is essential to our everyday operations when using version control.

Git is awesome as plugins in the path slip into the main binary completion.

* Manage multiple users
* Fix Configs (ala proxies)
* Fetch hard get data
* etc..

## Swap Users

`git swap` 

```shell
usage: ./git swap <.gitusers>
usage: ./git swap <username> <email>

Switch Local and Save to Config
usage: ./git swap [--new-user1 || -1] <username> <email>
usage: ./git swap [--new-user2 || -2] <username> <email>
usage: ./git swap [--new-user3 || -3] <username> <email>

Switch Global
usage: ./git swap [--global || -g] <username> <email>
```

### User Config

The configuration supports three different users [user1,user2,user3]

```ini
~/.gitusers
user1name="shadowbq"
user1email="shadowbq@gmail.com"
```

## Who Am I

`git whoami` - Show who you are based on global or local settings in a repo

```shell
$> git whoami
shadowbq <shadowbq@gmail.com>
```

## Downcase

Note: The global MDF in `~/.gitconfig` config is set to 'ignorecase'

Need I say more.. force downcase of filenames in repo. It will `git mv` the files to the new locations.
It will also set the current repo configuration:

`git config core.ignorecase false`

## Private

The wack-o-mole of fetching HTTPS git private repos.

Example usage: 

```shell
export GITHUB_TOKEN=${GITHUB_TOKEN} 
git private "${git_tag}" myorg private-repo "${filename}" "${archive:?}/${filename}"
```

Example usage: *less secure*

```shell
GITHUB_TOKEN=ABCDEFGHIJ0123456789 git private v0.0.1 myorg private-repo foo.tar.gz /var/tmp/foo.tar.gz
```

## Proxy Clear

Clearing any proxy settings that may be attached to the current checked out repo.

## Others

md-toc-creator - Markdown Table of Contents Creations script.
