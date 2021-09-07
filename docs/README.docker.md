# Docker

## Extension

The extension holds a few docker and k8s helper applications and functions


* docker-tags - Finding Docker images with specific tags in docker registry 
* docker-shell <image> - Common interactive bash in any container
* docker-remove-dangling-images - Docker rmi dangling=true
* docker-matrix-stopall - Stop all Service Images
  
### K8s 
  
* kubectl-config_swap - kubectl configuraiton switcher
  
### Matrix specific
  
* powerline-kubernetes-toggle - Enable/Disable Kubernetes namespace in SHELL Prompt
* Protainer.yaml - Docker Compose for init starting and stoping Portainer.io
* docker-matrix-portainer-start - Start Portainer.io

  
## Service Images 

Traditionally, container images are used for long running processes: services that are run on a server, not influencing the host because they are contained. Web servers, load balancers and databases are good examples of service images. These kind of containers can be easily compared to virtual machines

## Executable images

These kind of containers execute a single task, are short lived and maybe be removed after use. Examples are compilers (Golang), build tools (Maven), or other batch tooling (ImageMagick).

Docker and Containers have many use-cases including microservices, scheduling with k8s, etc. One very interesting usecase with
Docker is that it can be utilized to minimize the number of inter-dependencies on the OS. 

### Docker Security

There are four major areas to consider when reviewing Docker security:

* the intrinsic security of the kernel and its support for namespaces and cgroups;
* the attack surface of the Docker daemon itself;
* loopholes in the container configuration profile, either by default, or when customized by users.
* the “hardening” security features of the kernel and how they interact with containers.  
  
`cgroups` are not a sandboxing or isolation technique. Docker is also not a security measure. It's an alternative with less overhead to a VM. a process running as root can break out of its own cgroup and docker container. Docker assumes that programs 'play nice' and that you trust them.

As of Docker 1.10 User Namespaces are supported directly by the docker daemon. This feature allows for the root user in a container to be mapped to a non uid-0 user outside the container, which can help to mitigate the risks of container breakout. This facility is available but not enabled by default.

Docker containers are secure; especially if you run your processes as non-privileged users inside the container.

You can add an extra layer of safety by enabling AppArmor, SELinux, GRSEC, or another appropriate hardening system on the host machine running the docker daemon.  
  
* https://docs.docker.com/engine/security/  
  
## Applications
  
Many tools can be used to perform similar use cases: `chroot`, `flatpak`, `appimage`, `snap`.

Docker containers can’t be used everywhere so understanding when to use one of the others is also important.

||Snap|Flatpak|AppImage|
|---|---|---|---|
|Backer| Canonical| RedHat, Endless | Community |
|Target Systems|Desktop, Servers, & IoT|Desktop and Limited Server|Desktop and Servers|
|Android Like Permission Controls Toggles (GUI and CLI)|	Yes	|Yes	|No|
|Sandboxing Support|	Yes|	Yes|	Yes|
|Sandboxing Mandatory|	Yes|	Yes|	No|
|Sandboxing Platforms	|  AppArmor	|Bubblewrap| AppArmor, Firejail, Bubblewrap|
|Native Theme Support	|Yes (with caveats)|	Yes (with caveats)	|Yes (with caveats)|
|Support for Bundled Libraries|	Yes|	Yes|	Yes|
|App Portability|	Yes (with caveats)|	Yes (with caveats)|	Yes|
|Fully Contained Single Executable Support (similar to .exe files in windows)|	No|	No|	Yes|
|Online App Store|	Yes	|Yes|	Yes|
|Plugins for Desktop App Store Software|	Yes|	Yes|	No|
|Multi-version Parallel Apps Support|	Yes	|Yes	|Yes|
|Automatic Updates|	Yes|	Yes|	Yes (with caveats)|
|Chrome OS Support (through Crostini containers)|	Yes|	Yes|	Yes|
|App Size|	Varies but higher than AppImage|	Varies but higher than AppImage|	Lowest
|Number of Apps Available in the App Store|	Highest|	Lowest	|Somewhere in-between|
|Root user required| No | Sometimes | No| 
|Tooling Required| snapd| flatpak| self-executing|

“... AppImage works perfectly for ‘leaf-node’ desktop applications,” said (Canonical). A leaf-node application is one that doesn’t need to integrate with any other app. Snap was designed more to package apps with dependencies and related applications. “Snaps have a range of capabilities for describing those connections — interfaces, plugs and slots, as well as shared files and so on.”

In addition to that, (Canonical) told us that Snap was designed for higher levels of security compared to AppImage, partly because the team working on the mobile phone was focused on security and efficiency, and partly because Snap uses newer kernel capabilities.

### Examples of Executable Wrappers

Shell Execution with argv@ wrapper with STDIN 

```shell
#!/usr/bin/env bash
#docker run --rm -i --entrypoint "/bin/hadolint" hadolint/hadolint "--format json -" < "$@"
#docker run --rm -i hadolint/hadolint '/bin/hadolint' '--no-color' '-' < "$@"
docker run --rm -i hadolint/hadolint hadolint \
  --no-color \
  - < "$@"
```

Function for inclusions

```shell
mvn() {
  docker run --rm \
    -v $(pwd):/project \
    my_mvn $*
}
```

## References
  * https://linuxhint.com/snap_vs_flatpak_vs_appimage/
  * https://www.infoq.com/articles/docker-executable-images/
  * https://stackoverflow.com/questions/32727594/how-to-pass-arguments-to-shell-script-through-docker-run
  * https://dev.to/tomgranot/docker-shell-shortcuts-because-writing-full-commands-is-hard-33h
  * https://github.com/TomGranot/useful-snippets/blob/master/docker-bashrc/docker-bashrc.sh
  * https://github.com/koalalorenzo/docker-aliases
