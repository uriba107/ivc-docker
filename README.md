# BMS IVC Server "For Linux"
This Project allows an IVC server to run under linux, it utilized [Docker container](https://www.docker.com/) run IVC without installing multiple dependencies.
Obviously you would need a [Docker engine installed](https://docs.docker.com/engine/installation/linux/).

## Background
Based on the lightweight [Alpine Linux](https://www.alpinelinux.org/) and using [Wine](https://www.winehq.org/) to run the Windows binary.
Docker size when compiled is under 200MB and negates the need to install Wine massive dependencies on your production machine.

[Project page on dockerhub](https://hub.docker.com/r/108vfs/ivc/)

## Build Docker
 ``` Note: This stage is not mandatory,
 you can just install with the script and pull image from dockerhub ```
 1. cd into build folder
 2. Run 'build.sh' script as a docker enabled user (root should work)

## Install IVC Server
install script and systemd are ubuntu compatible and tested on Ubuntu 16.04.
#### Ubuntu
 1. Copy BMS' IVC folder to the folder containing the install script on the server.
 2. Run 'install.sh' script as root.

#### Other Dists
please adjust scripts to fit your OS.