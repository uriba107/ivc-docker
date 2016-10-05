#!/bin/bash
# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPT_PATH=`dirname $SCRIPT`

APP_NAME="IVC"
APP_PATH="/opt/ivc"
APP_BIN="IVC Server.exe"

DOCKER=$(which docker)

function check_root(){
  if [ $(id -u) -ne 0 ]; then
    echo "Please run as root (sudo is good enough)"
    exit 1
  fi
}

function create_folder() {
  echo "Creating external folder for $APP_NAME"
  mkdir -p $APP_PATH
  chmod 755 $APP_PATH
  if [ ! -f "$APP_PATH/$APP_BIN" ]; then
    for object in *; do
      if [ -d $object ] && [ -f "./$object/$APP_BIN" ]; then
        echo "$APP_NAME found! hurray.. copying"
        cp -r ./$object/* $APP_PATH
        break
      fi
    done
  else
    echo "$APP_NAME binaries are already in place"
  fi
  
  mkdir -p /etc/ivc
  cp $SCRIPT_PATH/conf/ivc-server.conf /etc/ivc/

  if [ ! -f "$APP_PATH/$APP_BIN" ]; then
    read -n 1 -s -p "Please make sure $APP_NAME folder from BMS bin is copied to $APP_PATH.. press any key to continue."
    echo ""
  fi
}

function install_systemd() {
  if [ -d /usr/lib/systemd/system ]; then
    SYSTEMD_PATH=/usr/lib/systemd/system/
  else
    SYSTEMD_PATH=/lib/systemd/system/
  fi
  echo "Creating service"
  cp ${SCRIPT_PATH}/init/ivc-server.service ${SYSTEMD_PATH}
  /bin/systemctl daemon-reload
  echo "Enabling IVC server Autostart"
  /bin/systemctl enable ivc-server
}

function service_start() {
  if [ -f "$APP_PATH/$APP_BIN" ]; then
    echo "Starting $APP_NAME Service"
    echo "Note: this part may take a while as docker container is pulled on initial activation"
    $DOCKER pull 108vfs/ivc
    service ivc-server start
  else {
    create_folder
    service_start
  }
  fi
}

function main() {
  check_root 
  install_systemd
  service_start
}

main $@
