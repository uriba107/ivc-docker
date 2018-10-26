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
## Dumb-init
RUN apk add --no-cache -t build-deps gcc curl musl-dev \
 && curl -L https://github.com/Yelp/dumb-init/archive/master.tar.gz | tar -C /tmp -xzf - \
 && gcc -std=gnu99 -s -Wall -Werror -O3 -o /usr/bin/dumb-init /tmp/dumb-init-master/dumb-init.c \
 && apk del build-deps

## install wine
RUN apk add --no-cache -t ivc-deps freetype libpng wine bash

EXPOSE 9987 9988 9989

#Move bineries over
WORKDIR /opt
ADD wrapper/launcher.sh /opt

## create user
#RUN adduser -S ${APP_NAME}
#RUN chown ${APP_NAME} -R ${APP_ROOT}

# configure wine
#USER ${APP_NAME}
RUN /usr/bin/wineboot --init

VOLUME ["/opt/ivc"]
ENTRYPOINT ["/usr/bin/dumb-init", "--" ]
CMD [ "/opt/launcher.sh" ]
