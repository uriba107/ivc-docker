#!/bin/bash
# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPT_PATH=`dirname $SCRIPT`

DOCKER=$(which docker)

function check_permissions(){
  id | grep -q docker
  RETVAL=$?
  if [ $RETVAL -ne 0 ]; then
    echo "Please run as root (sudo is good enough)"
    exit 1
  fi
}
function build_docker() {
  echo "Building docker..."
  $DOCKER build -t 108vfs/ivc ${SCRIPT_PATH}
}

function main() {
  check_permissions
  build_docker
}

main $@
