#!/bin/sh


function check_bin(){
  local APP_NAME=$1
  local PATH=$2
  local BIN=$3
  echo "${PATH}/${BIN}"
  if [ ! -f "${PATH}/${BIN}" ]; then
    echo "Could not find ${BIN} at ${PATH}... Please copy ${APP_NAME} to your local folder at the specified path"
    exit 1
  fi
}

function start_app(){
  local APP_NAME=$1
  local PATH=$2
  local BIN=$3
  local IVC_PASSWD=$4

  local ARGS=""
  if [ ! -z $IVC_PASSWD ]; then
    ARGS="$ARGS -w ${IVC_PASSWD}"
  fi
  echo "Launching ${APP_NAME}.."
  /usr/sbin/dumb-init -- /usr/bin/wine "${PATH}/${BIN}" $ARGS
}

function main(){
  local APP_NAME=$APP_NAME
  local PATH=$APP_PATH
  local BIN="IVC Server.exe"
  local INPUT=$1

  if [ $INPUT == "bash" ] || [ $INPUT == "sh" ]; then
    PATH=$PATH:/bin:/sbin:/usr/sbin:/usr/bin
    /bin/sh
  else {
    check_bin $APP_NAME $PATH "${BIN}"
    start_app $APP_NAME $PATH "${BIN}" $INPUT
  }
  fi

}

main $@
