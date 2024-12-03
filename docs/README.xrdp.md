# RDP for Linux

## Server

`apt install xrdp`

## Clients

Snap installation `sudo snap install remmina`

```
sudo snap connect remmina:audio-record :audio-record
sudo snap connect remmina:audio-playback :audio-playback
sudo snap connect remmina:avahi-observe :avahi-observe
sudo snap connect remmina:cups-control :cups-control
sudo snap connect remmina:mount-observe :mount-observe
sudo snap connect remmina:password-manager-service :password-manager-service
sudo snap connect remmina:ssh-keys :ssh-keys
sudo snap connect remmina:ssh-public-keys :ssh-public-keys
```
