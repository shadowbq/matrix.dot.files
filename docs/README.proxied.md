# Proxied - General proxy settings for many applications

There are a few well known things to enable proxies, but frankly its still a mess in the POSIX world.

* reference: https://unix.stackexchange.com/questions/212894/whats-the-right-format-for-the-http-proxy-environment-variable-caps-or-no-ca

Set your proxy in the `.matrix_config` and enable the helper extension (home/.matrix/extensions/proxied/.bash_extension).

```shell
export matrix_ext_proxy=true
export globalurl_proxy="proxyUsername:proxyPassword@proxy.server.com:port"
# (optional) export socks_proxy="socks.server.com:1080"
# (optional) export ignore_proxy="127.0.0.1,169.254.169.254,localhost" <- default
# (optional) export ignore_proxy="$ignore_proxy,169.254.169.123,localhost.localdomain"
```

Automatic configuration if you load the `proxied extension` in matrix.dot.files:

```shell
## Configured from the proxied extension automatically
export NO_PROXY=127.0.0.1,169.254.169.254,localhost
export no_proxy=$NO_PROXY
export noProxy=$NO_PROXY
export noproxy=$NO_PROXY
export HTTP_PROXY=http://my.proxy.location:6124
export HTTPS_PROXY=$HTTP_PROXY
export http_proxy=$HTTP_PROXY
export https_proxy=$HTTPS_PROXY

export ftp_proxy=http://<YOUR.FTP-PROXY.URL:PORT>
export socks_proxy=http://<YOUR.SOCKS-PROXY.URL:PORT>
export FTP_PROXY=$ftp_proxy
export SOCKS_PROXY=$socks_proxy
```

Some clients support the `no_proxy` environment variable that specifies a set of domains for which the proxy should not be consulted


## Additional Application proxies configured for you

```shell
git config — global http.proxy $HTTP_PROXY
git config — global https.proxy $HTTP_PROXY
```

### git over SSH 

This is an example, and one is packaged into the config that ships. Add the following to your `~/.ssh/config` file:

```
host github.com
     port 22
     user git
     ProxyCommand connect-proxy -S <YOUR.SSH-PROXY.URL:PORT> %h %p
```

### kubeadmin (k8s)

`kubeadm` commands specifically use these shell variables for proxy configuration. Ensure they are set your running terminal before running kubeadm commands.

```
export http_proxy=http://proxy.example.com:80
export https_proxy=http://proxy.example.com:443
export no_proxy=.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,`hostname`,localhost
```

## On-Off

`proxy_set` - Set all these proxies based on the global proxy config

`proxy_unset` - remove all the proxies configured as best as we can.

`proxy-show` - show what is configured to use proxies as best as we can.


## Existing Alternative Approaches

There are a number of existing pieces to this puzzle, none of them ideal...

### Environment variables

There is a long-standing expectation that, especially for command-line tools, one can set environment variables such as http_proxy and https_proxy, to use a specific proxy. This has a number of disadvantages — it is a static configuration which cannot change as network connectivity changes (i.e. moving from one network to another, joining a VPN), and there is no way to reference a more complicated configuration which is expressed with a PAC file.

### Tinyproxy for upstream local use

Using Tinyproxy with upstream support within docker is real crossplatform solution especially if you can get libproxy support compiled in. 

Docker Example:  

* https://github.com/Travix-International/docker-tinyproxy
* https://hub.docker.com/r/travix/tinyproxy

Tinyproxy:  

* https://tinyproxy.github.io/
* https://github.com/tinyproxy/tinyproxy

Tinyproxy with libproxy homebrew (mixed in):  

Note: this homebrew used the ancient 10yr old tinyproxy repo https://github.com/andyetitmoves/tinyproxy 
But the Branch is 4yrs old https://github.com/andyetitmoves/tinyproxy/tree/libproxy-upstream

* https://github.com/andyetitmoves/homebrew-public/blob/master/Formula/tinyproxy-libproxy.rb

### libproxy

Libproxy is designed to offer a simple API to applications to answer the what proxy? question. It has numerous back ends for obtaining information — including doing the WPAD lookup for itself, as well as looking in the GNOME configuration or honouring the environment variables, amongst other methods not mentioned here.

One of the big disadvantages of libproxy is that it loads a JavaScript interpreter for itself behind the scenes, into every process which uses a PAC file. **It also re-downloads the PAC file for each request**. Many existing applications already have libproxy support, including glib-networking, which goes to the trouble of spawning its own 'glib-pacrunner' process to work around some of the problems mentioned above. (In addition to its implementation issues, libproxy is also not a great API; it has no way of signaling an error to the caller; if it can't determine the proxy settings for whatever reason, it just silently ignores the problem and assumes no proxy is needed.)

* https://github.com/libproxy/libproxy  
* http://libproxy.github.io/libproxy  
* https://formulae.brew.sh/formula/libproxy

### GNOME proxy configuration

At `org.gnome.system.proxy`, GNOME keeps its own proxy settings. This can handle PAC files, but still has the problem that it is system-wide, and does not adjust according to the currently-connected network(s). Additionally, the user's proxy settings aren't visible to root processes, so things like yum won't pick up these settings.

Obviously this doesn't work for macos, and there is more than one gnome.system now in linux.

### PacRunner

PacRunner is a simple standalone dæmon which communicates via D-Bus. It is designed to receive its proxy configuration from a trusted source such as ConnMan or NetworkManager, then simply exposes a method on D-Bus for applications to ask the what proxy? question.

There exists a back end for the original libproxy, which can be configured as the highest priority and do nothing except query PacRunner. In fact, PacRunner also offers a trivial replacement for the libproxy.so shared library, which has none of libproxy's complexity and which can only do that one thing. These approaches provide compatibility for existing applications which already have libproxy support. Alternatively, applications can query PacRunner directly via D-Bus instead of using the libproxy API.

But again.. this is garbage when it comes to macos. 

### SOCKS 5 / SSH Tunnels

Simple Proxy with SSH: Connect to a server (HOST) on which you have an account (USER) as follows

`ssh -D PORT USER@HOST`

Here are two other use cases:

the application you want to use handles SOCKS5 proxies (for example Firefox), then you just have to configure it to use the proxy.
the application you want to use does not handle SOCKS proxies, then you can try to use tsocks or proxychains-ng.

`proxychains <program>`

`/etc/proxychains.conf`. You may have to uncomment the last line (set by default to use Tor), and replace it with the parameters of the SOCKS proxy. For example, if you are using the same SOCKS5 proxy as above, you will have to replace the last line by:

```shell
socks5 127.0.0.1 8080
```

- or -

tsocks `/etc/tsocks.conf`

```shell
server = 127.0.0.1
server_port = 8080
server_type = 5
default_user = ""
default_pass = ""
```

#### ENVS with SOCK5

curl supports this. 

`export all_proxy="socks5://your.proxy:1080"`
