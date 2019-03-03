#!/usr/bin/dumb-init /bin/sh

function check_bin(){
  local APP_NAME=$1
  local IVC_PATH=$2
  local BIN=$3
  echo "${IVC_PATH}/${BIN}"
  if [ ! -f "${IVC_PATH}/${BIN}" ]; then
    echo "Could not find ${BIN} at ${IVC_PATH}... Please copy ${APP_NAME} to your local folder at the specified path"
    exit 1
  fi
}

function start_app(){
  local APP_NAME=$1
  local IVC_PATH=$2
  local BIN=$3
  local IVC_PASSWD=$4

  local ARGS=""

  if [ ! -z $IVC_PASSWD ] && [ ! $IVC_PASSWD == "none" ]; then
    ARGS="$ARGS -w ${IVC_PASSWD}"
  fi
  
  local WINE_BIN="/usr/bin/wine"
  if [ ! -f "${WINE_BIN}" ]; then
    WINE_BIN=${WINE_BIN}64
  fi

  echo "Launching ${APP_NAME}.."
  /usr/bin/dumb-init -- ${WINE_BIN} "${IVC_PATH}/${BIN}" $ARGS
}

function main(){
  local APP_NAME=$APP_NAME
  local IVC_PATH=$APP_PATH
  local BIN="IVC Server.exe"
  local INPUT=${1:-"none"}

  if [ $INPUT == "bash" ] || [ $INPUT == "sh" ]; then
    PATH=$PATH:/bin:/sbin:/usr/sbin:/usr/bin:${APP_PATH}
    /bin/bash
  else {
    check_bin $APP_NAME $IVC_PATH "${BIN}"
    start_app $APP_NAME $IVC_PATH "${BIN}" $INPUT
  }
  fi
}

main $@
