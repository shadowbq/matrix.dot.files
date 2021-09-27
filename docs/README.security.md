# Security

* [README - Sandboxes](README.sandbox.md) - Running shell applications in a sandbox.
* [README - Secrets](README.secrets.md) - Managing your shell secrets securely

There are some security mechanism in `matrix.dot.files`, but mostly they live at the system security level.  

Items like CIS hardening are *out-of-scope* for `matrix.dot.files`

* https://cloudsecuritylife.com/cis-ubuntu-script-to-automate-server-hardening/
* https://github.com/florianutz/ubuntu2004_cis

## Two Factor System Authentication

Requires: root access to modify SSHD.

https://github.com/google/google-authenticator-libpam

Note: These are specific to Ubuntu, but will work across `sshd` backed by pam.

You could install PAM inforced TWO factor via the `google-authenticator-libpam`

```shell
sudo apt install libpam-google-authenticator
#brew install google-authenticator-libpam
google-authenticator
```

Next you’ll have to require Google Authenticator for SSH logins. To do so, open the /etc/pam.d/sshd file on your system (for example, with the sudo nano /etc/pam.d/sshd command) and add the following line to the file:

`auth required pam_google_authenticator.so`

macos: Add 2-factor authentication for ssh:

```shell
echo "auth required $(brew --prefix)/opt/google-authenticator-libpam/lib/security/pam_google_authenticator.so" \
  | sudo tee -a /etc/pam.d/sshd
```

Next, open the `/etc/ssh/sshd_config` file, locate the ChallengeResponseAuthentication line, and change it to read as follows:

```ruby
ChallengeResponseAuthentication yes
```

(If the ChallengeResponseAuthentication line doesn’t already exist, add the above line to the file.)

Finally, restart the SSH server so your changes will take effect:

linux:

```shell
sudo service ssh restart
```

macos:

```shell
sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist
```

## List uninstalled security patches

### Ubuntu

```shell
sudo unattended-upgrade --dry-run -d 2> /dev/null | awk '/Checking/ { print $2 }'
```
