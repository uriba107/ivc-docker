#!/usr/sbin/dumb-init /bin/sh


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

  echo "Launching ${APP_NAME}.."
  /usr/sbin/dumb-init -- /usr/bin/wine "${PATH}/${BIN}"
}

function main(){
  local APP_NAME=${1:-${APP_NAME}}
  local PATH=${2:-$APP_PATH}
  local BIN=${3:-"IVC Server.exe"}

  if [ $APP_NAME == "bash" ] || [ $APP_NAME == "sh" ]; then
    /bin/sh
  else {
    check_bin $APP_NAME $PATH "${BIN}"
    start_app $APP_NAME $PATH "${BIN}"
  }
  fi

}

main $@

