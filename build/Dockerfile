######################
### BMS IVC server ###
######################
FROM scratch
MAINTAINER uri_ba <uri@uriba.org>
LABEL Description="BMS IVC server" Vendor="Benchmark Sims" Version="0.0.2"



ADD alpine/rootfs.tar.gz /
# ensure UTC instead of the default GMT
COPY alpine/UTC /etc/localtime

ENV APP_NAME ivc
ENV APP_ROOT /opt
ENV APP_PATH ${APP_ROOT}/${APP_NAME}
## upgrade everything just in case
RUN apk upgrade --no-cache

## install wine
RUN apk add --no-cache -t ivc-deps dumb-init bash ncurses freetype libpng gnutls-c++ wine

EXPOSE 9987 9988 9989

#Move bineries over
WORKDIR /opt
ADD wrapper/launcher.sh /opt
#ADD IVC /opt/ivc 

## Install xvfb
#RUN apk add --no-cache -t wine-deps xvfb

# configure wine
#USER ${APP_NAME}
#RUN /usr/bin/wineboot --init

#ADD bin/xvfb-run /usr/bin
#RUN xvfb-run /usr/bin/wineboot 

VOLUME ["/opt/ivc"]
ENTRYPOINT ["/usr/bin/dumb-init", "--" ]
CMD [ "/opt/launcher.sh" ]
