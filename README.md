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
1. Please adjust scripts to fit your OS.

## Running IVC server manually
If from some reason you chose not to use the install script, or couldn't get the init script to work on your system, You can pretty much do it manually.

1. Start by copying IVC files to their proper location. the Docker container does not include the IVC binary, among other reasons, to allow you as a user to use the proper IVC server for the BMS version you are using. you should place the binarys are "/opt/ivc"
2. Initially you'll need to create the Docker container on you machine </br>
``` docker create --name ivc-server -v /opt/ivc:/opt/ivc -p 9987-9989:9987-9989/udp 108vfs/ivc  ```
This will create a container called "ivc-server" which already links up the binary folder from your hard drive to the container and sets up the port forwarding needed. 
3. Once container is created all you need to do is start it:</br>
``` docker start -a ivc-server ```</br>
The container will persist a reboot, so you'll only need to start it (no need to re-create)
4. To stop or restart just use ``` docker stop ivc-server ``` or ``` docker restart ivc-server ```

``` Note: The install script does all of this of you if you are using it ```