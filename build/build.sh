#!/bin/bash
# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPT_PATH=`dirname $SCRIPT`

DOCKER=$(which docker)
DOCKER_USER=108vfs
DOCKER_NAME="ivc-test"
DOCKER_ARCH_64=0

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
  $DOCKER build -t ${DOCKER_USER}/${DOCKER_NAME} ${SCRIPT_PATH}
}

function get_alpine() {
  ALPINE_VERSION="latest-stable"
  ALPINE_ARCH="x86"
  if [ $DOCKER_ARCH_64 -eq 1 ]; then
    ALPINE_ARCH="x86_64"
  fi

  ALPINE_URL="http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/releases/${ALPINE_ARCH}"
  ALPINE_YAML="${ALPINE_URL}/latest-releases.yaml"
  ALPINE_LATEST=$(curl ${ALPINE_YAML} | grep "file: alpine-minirootfs" | awk -F": " '{print $2}')
  ALPINE_GET="${ALPINE_URL}/${ALPINE_LATEST}"

  echo  ${ALPINE_GET}
  echo "Getting core alpine..."
  curl -sS -o alpine/rootfs.tar.gz ${ALPINE_GET}
}

function clean_alpine() {
  echo "some cleanup..."
  rm alpine/rootfs.tar.gz
}

function main() {
  while :
    do
      case "$1" in
       -d | --docker)
          DOCKER_NAME=$2
          shift 2
          ;;
      -64)
          DOCKER_ARCH_64=1
          shift
          ;;
      --) # End of all options
	  shift
	  break;
          ;;
      -*)
	  echo "Error: Unknown option: $1" >&2
	  exit 1
	  ;;
      *)  # No more options
#          echo ${DOCKER_NAME}
#          echo ${DOCKER_ARCH_64}
	  break
	  ;;
      esac
  done

  check_permissions
  get_alpine
  build_docker
  clean_alpine
}

main "$@"
