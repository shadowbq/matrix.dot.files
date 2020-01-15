#!/bin/bash
# Copyright 2020 D2iQ ospo@d2iq.com

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#       http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DOCKER_IMAGE=onedata/docker-openvpn-kube-for-mac:1.3.0

# colors
GREEN='\033[1;32m'
RED='\033[0;31m'
WHITE='\033[1;37m'
NOCOLOR='\033[0m'

# marks
TICK='\xE2\x9C\x94'
CROSS='\xE2\x9D\x8C'

create() {
  command -v docker > /dev/null 2>&1 || { echo >&2 "couldn't find docker client. Aborting..."; exit 1; }

  [ ! "$(docker ps | grep docker-openvpn)" ] || { echo 'It seems VPN is already running. Do Nothing.'; exit 1; }

  docker container rm docker-openvpn > /dev/null 2>&1
  docker volume rm ovpn-data > /dev/null 2>&1

  printf "${GREEN}"

  printf "Creating docker volume ..........."
  error=$(docker volume create --name ovpn-data 2>&1 >/dev/null)
  check "$error"

  printf "Initializing vpn config .........."
  error=$(docker run -v ovpn-data:/etc/openvpn --rm $DOCKER_IMAGE ovpn_genconfig -u udp://localhost 2>&1 >/dev/null)
  check "$error"

  printf "Creating CA (may take sometime) .."
  error=$(docker run -v ovpn-data:/etc/openvpn --rm -i -e "EASYRSA_BATCH=1" -e "EASYRSA_REQ_CN=Default CA" $DOCKER_IMAGE ovpn_initpki nopass 2>&1 >/dev/null)
  check "$error"

  printf "Creating client certificate ......"
  error=$(docker run -v ovpn-data:/etc/openvpn --rm -i $DOCKER_IMAGE easyrsa build-client-full DockerForMac nopass 2>&1 >/dev/null)
  check "$error"

  printf "Starting vpn server .............."
  error=$(docker run --dns 8.8.8.8 --restart=always -v ovpn-data:/etc/openvpn --name docker-openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN $DOCKER_IMAGE 2>&1 >/dev/null)
  check "$error"

  printf "Exporting client certificate ....."
  docker run -v ovpn-data:/etc/openvpn --rm $DOCKER_IMAGE ovpn_getclient DockerForMac > ./DockerForMac.ovpn
  printf "${TICK}\n"

  printf "${WHITE}\n"

  echo 'Please follow the below instructions                    '
  echo '********************************************************'
  echo '1. Install (or Run) Tunnelblick                         '
  echo '2. Run open ./DockerForMac.ovpn                         '
  echo '3. In Tunnelblick, select `Connect DockerForMac`        '
  echo '4. Wait for the server response (it will take a minute) '

  printf "${NOCOLOR}\n"
}

destroy() {
  printf "${GREEN}"

  printf "Stopping vpn server ........."
  docker container stop docker-openvpn > /dev/null 2>&1
  docker container rm docker-openvpn > /dev/null 2>&1
  printf "${TICK}\n"

  printf "${WHITE}\n"
  echo 'In Tunnelblick, select `Disconnect DockerForMac` '
  printf "${NOCOLOR}\n"
}

check() {
  if [ $? -eq 0 ]; then
    printf "${TICK}\n"
  else
    printf "${CROSS}\n"
    printf "${RED}ERROR: %s\n" "$1"
    printf "${NOCOLOR}"
    exit 1
  fi
}

case "$1" in
  create)
    create
    ;;
  destroy)
    destroy
    ;;
  *)
    echo $"Valid arguments are: create | destroy"
    exit 1
esac

