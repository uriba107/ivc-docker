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
install script and systemd are ubuntu compatible and tested on Ubuntu 16.04 and CentOS7.
#### Ubuntu 16.04/CentOS 7.0
 1. Copy BMS' IVC folder to the folder containing the install script on the server.
 2. Run 'install.sh' script as root.

#### Other Dists
Please adjust scripts to fit your OS.

#### Running IVC server manually
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

## Available Configuration
IVC server can be customized by editing '/etc/ivc/ivc-server.conf'.
### IVC Password
IVC server can be password protected. This is achieved by uncommenting "PASSWD" variable and putting in the password you wish to use in clear text.

### Listen Addres
IVC server will default to bind to all IP addresses on the server, in some cases, for example, when Teamspeak on a default port is to co-exist on the server.
To bind IVC to a specific IP, please uncomment "LISTED_ADDR" and type in the required IP.

### Port settings
IVC port can be changed, this is useful in case you would want to run Teamspeak on a default port and don't have an additional IP address.
To change the port you would need to edit two variables. 'PORT' and 'ENDPORT'. please note that ENDPORT <U>MUST</U> be PORT+2.

## Upgrading IVC version
When a new BMS update is released, it may include an updated IVC server. To allow you to easly upgrade the IVC version without waiting for a new docker to be released. the binaries are being loaded from an external directory on your server. 

To update the IVC server version all you need to do is re-upload the BMS IVC folder to '/opt/ivc' while replacing the original content there (i.e. the old IVC) and restart the docker (``` service ivc-server restart ``` shoult do the trick if installed using the script)

## Known Limitations
  * Currently only one IVC server per-server is supported. However, I you want it enough, support for two servers is possible
  * IVC binaries are NOT included in the Docker file. This is done to allow a quick change of binaries without the need to wait for an updated docker to be pushed. You'll need to copy them to the server manually.
