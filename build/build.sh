#!/bin/bash
# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPT_PATH=`dirname $SCRIPT`

DOCKER=$(which docker)
DOCKER_USER=108vfs
DOCKER_NAME=ivc

function check_permissions(){
  id | grep -q docker
  RETVAL=$?
  if [ $RETVAL -ne 0 ] && [ $(id -u) -ne 0 ]; then
    echo "Please run as root (sudo is good enough)"
    exit 1
  fi
}

function build_docker() {
  echo "Building docker..."
  $DOCKER build --pull -t ${DOCKER_USER}/${DOCKER_NAME} ${SCRIPT_PATH}
}

function get_alpine() {
  ALPINE_URL="http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86"
  ALPINE_YAML="${ALPINE_URL}/latest-releases.yaml"
  ALPINE_LATEST=$(curl ${ALPINE_YAML} | grep "file: alpine-minirootfs" | awk -F": " '{print $2}')
  ALPINE_GET="${ALPINE_URL}/${ALPINE_LATEST}"

  echo "Getting core alpine..."
  curl -sS -o alpine/rootfs.tar.gz ${ALPINE_GET}
}

function clean_alpine() {
  echo "some cleanup..."
  rm alpine/rootfs.tar.gz
}

function main() {
  check_permissions
  get_alpine
  build_docker
  clean_alpine
}

main $@
